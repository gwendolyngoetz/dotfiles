#!/usr/bin/python3
# sway port: i3ipc connects via $SWAYSOCK automatically; only output-name
# parsing changed (see screen_number).
import asyncio
import argparse
from i3ipc.aio import Connection
from pprint import pprint


class WorkspaceSwapper:
    def __init__(self, debug: bool = False):
        self.debug = debug

    async def run(self, screen1: int, screen2: int):
        i3 = await Connection().connect()
        num_workspaces, workspaces = await self.get_workspaces(i3)

        is_valid = self.validate_input(screen1, screen2, num_workspaces)

        if not is_valid:
            exit(-1)

        self.print(workspaces)

        workspace1 = workspaces[str(screen1)]
        workspace2 = workspaces[str(screen2)]

        await self.swap_workspace(i3, workspace1, workspace2)
        await self.swap_workspace(i3, workspace2, workspace1)
        await self.focus_workspace(i3, workspaces["focused"])

    def validate_input(self, screen1, screen2, num_workspaces):
        is_valid = True

        if screen1 < 1:
            print(f"screen1: {screen1} must be > 0")
            is_valid = False

        if screen1 > num_workspaces:
            print(f"screen1: {screen1} must be <= {num_workspaces}")
            is_valid = False

        if screen2 < 1:
            print(f"screen2: {screen2} must be > 0")
            is_valid = False

        if screen2 > num_workspaces:
            print(f"screen2: {screen2} must be <= {num_workspaces}")
            is_valid = False

        return is_valid

    async def get_workspaces(self, i3):
        formatted_workspaces = {}

        workspaces = list(filter(lambda x: x.visible, await i3.get_workspaces()))

        for workspace in workspaces:
            screen_id = str(self.screen_number(workspace.output))

            formatted_workspaces[screen_id] = {
                "num": workspace.num,
                "screen": workspace.output,
                "focused": workspace.focused,
            }

            if workspace.focused:
                formatted_workspaces["focused"] = {
                    "num": workspace.num,
                    "screen": workspace.output,
                    "focused": workspace.focused,
                }

        return (len(workspaces), formatted_workspaces)

    @staticmethod
    def screen_number(output: str) -> int:
        """1-based screen number from an output name.

        sway reports DRM connector names (DP-1, HDMI-A-1), which are already
        1-indexed. i3/xrandr names (DisplayPort-0) are 0-indexed, so bump those
        by one to keep the same CLI numbering as the i3 version.
        """
        number = int(output.rsplit("-", 1)[1])

        if output.startswith("DisplayPort-"):
            number += 1

        return number

    async def swap_workspace(self, i3, workspace1, workspace2):
        num = workspace1["num"]
        screen = workspace2["screen"]

        command1 = f"[workspace={num}] move workspace to output {screen}"
        command2 = f"workspace {num}:{num}"

        self.print(command1)
        self.print(command2)

        if not self.debug:
            await i3.command(command1)
            await i3.command(command2)

    async def focus_workspace(self, i3, workspace):
        num = workspace["num"]

        command1 = f"workspace {num}:{num}"

        self.print(command1)

        if not self.debug:
            await i3.command(command1)

    def print(self, obj):
        if self.debug:
            pprint(obj)


async def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("screen1", type=int)
    parser.add_argument("screen2", type=int)
    parser.add_argument("--debug", action=argparse.BooleanOptionalAction)
    args = parser.parse_args()

    swapper = WorkspaceSwapper(debug=args.debug)
    await swapper.run(args.screen1, args.screen2)


if __name__ == "__main__":
    asyncio.run(main())

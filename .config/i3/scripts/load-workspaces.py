#!/usr/bin/python3
import argparse
import subprocess

class WorkspaceBuilder():
    def __init__(self, debug: bool = False):
        self.debug = debug

        self.workspaces = {
            1: ['alacritty', 'firefox'],
            2: ['firefox', 'firefox', 'alacritty'],
            3: ['virtualbox'],
            4: ['slack', 'teams', 'firefox'],
            8: ['alacritty'],
            9: ['alacritty', 'alacritty', 'alacritty']

        }

        self.applications = {
            'alacritty': 'alacritty --working-directory ~',
            'firefox': 'firefox',
            'virtualbox': 'vboxmanage startvm \'Windows10\'',
            'slack': 'slack',
            'teams': 'teams'
        }

    def run(self, workspaces: list):
        commands = []
        has_errors = False

        for workspace in workspaces:
            try:
                commands.append('i3-msg "{0}"'.format(self.build_command(workspace)))
            except Exception as error:
                has_errors = True
                print(error)

        self.print_debug(commands)
        self.run_commands(commands, has_errors)

    def print_debug(self, commands: list):
        if self.debug:
            for cmd in commands:
                print(cmd)

    def run_commands(self, commands: list, has_errors: bool):
        if has_errors:
            return

        if self.debug:
            return

        for cmd in commands:
            subprocess.call(cmd, shell=True, stdout=subprocess.DEVNULL)

    def build_command(self, workspace: int) -> str:
        if workspace not in self.workspaces:
            raise Exception('Workspace "{0}" not configured'.format(workspace))

        cmd = self.build_workspace_cmd(workspace)

        for application in self.workspaces[workspace]:
            cmd += self.build_application_cmd(application)

        return cmd.rstrip()

    def build_workspace_cmd(self, workspace: int) -> str:
        workspace_cmd = 'workspace {0}:{0};'.format(workspace)
        layout_cmd = 'append_layout ~/.config/i3/workspaces/workspace-{0}.json; '.format(workspace)
        return '{0} {1}'.format(workspace_cmd, layout_cmd)
    
    def build_application_cmd(self, application: str) -> str:
        cmd = self.applications[application]
        return 'exec --no-startup-id {0}; '.format(cmd)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('workspaces', nargs='+', type=int)
    parser.add_argument('--debug', action=argparse.BooleanOptionalAction)
    args = parser.parse_args()

    WorkspaceBuilder(debug=args.debug).run(workspaces=args.workspaces)

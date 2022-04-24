# This is an alternative approach. Single line in git repo.
override_git_prompt_colors() {
  GIT_PROMPT_THEME_NAME="Primary"

  GIT_PROMPT_PREFIX="[ "
  GIT_PROMPT_SUFFIX=" ]"
  GIT_PROMPT_SEPARATOR=" |"
  GIT_PROMPT_STAGED=" ${Red}● ${ResetColor}"
  GIT_PROMPT_CONFLICTS=" ${Red}✖ ${ResetColor}"
  GIT_PROMPT_CHANGED=" ${Blue}✚ ${ResetColor}"
  GIT_PROMPT_UNTRACKED=" ${Cyan}…${ResetColor}"
  GIT_PROMPT_STASHED=" ${BoldBlue}⚑ ${ResetColor}"
  GIT_PROMPT_CLEAN=" ${BoldGreen}✔ ${ResetColor}"

  GIT_PROMPT_COMMAND_OK="${Green}✔ "
  GIT_PROMPT_COMMAND_FAIL="${Red}✘ "

  hostname=$(hostname -s)
  NAME_HOST="${BoldGreen}${USER}@${hostname}${ResetColor}"

  #GIT_PROMPT_START_USER="_LAST_COMMAND_INDICATOR_"
  #GIT_PROMPT_END_USER="\n${NAME_HOST}:${BoldBlue}${PathShort}${ResetColor}$ "
  GIT_PROMPT_START_USER="${NAME_HOST}:${BoldBlue}${PathShort}${ResetColor}\n_LAST_COMMAND_INDICATOR_"
  GIT_PROMPT_END_USER="${ResetColor} $ "
  GIT_PROMPT_END_ROOT="${BoldRed} # "

}

reload_git_prompt_colors "Primary"


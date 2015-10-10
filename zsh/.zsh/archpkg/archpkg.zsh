#!/usr/bin/env zsh

# ==============================================================================
# archpkg 函数
# 提供slackpkg 式的包管理
#
#             By 秦凡东
# ==============================================================================
function archpkg {
  if [[ 0 == $# ]]; then
    set -- "help"
  fi

  if [[ ! -f /usr/bin/pacman ]]; then
    echo "未发现pacman 指令"
    return 1
  fi

  while true; do
    case "$1" in
      update)
        shift
        sudo pacman -Sy
        if [[ -f /usr/bin/pkgfile ]]; then
          pkgfile --update
        fi
        return $?
        ;;
      check-updates)
        shift
        sudo pacman -Qu $@
        return $?
        ;;
      upgrade-all)
        shift
        sudo pacman --needed --noconfirm --color auto -Sy linux-headers
        sudo pacman --noconfirm --color auto -Su
        if [[ -f /usr/bin/pkgfile ]]; then
          pkgfile --update
        fi
        return $?
        ;;
      clean-system)
        local result
        shift
        result=( $(pacman -Qqdt) )
        if [[ 0 != ${#result[@]} ]]; then
          sudo pacman --noconfirm --color auto -R ${result[@]}
        fi
        sudo pacman --noconfirm --color auto -Sc
        return $?
        ;;
      install)
        shift
        if [[ 0 == $# ]]; then
          set -- 'help'
          continue
        fi
        sudo pacman --needed --color auto -S $@
        return $?
        ;;
       reinstall)
        shift
        if [[ 0 == $# ]]; then
          set -- 'help'
          continue
        fi
        sudo pacman --color auto -S $@
        return $?
        ;;
      remove)
        local result
        shift
        if [[ 0 == $# ]]; then
          set -- 'help'
          continue
        fi
        result=( $(pacman -Qqs $1) )
        if [[ 0 != ${#result[@]} ]]; then
          sudo pacman --color auto -Rsn ${result[@]}
        fi
        return $?
        ;;
      download)
        shift;
        if [[ 0 == $# ]]; then
          set -- 'help'
          continue
        fi
        sudo pacman --color auto -Sw $@
        return $?
        ;;
      info)
        shift
        if [[ 0 == $# ]]; then
          set -- 'help'
          continue
        fi
        pacman --color auto -Si $@
        return $?
        ;;
      search)
        shift
        if [[ 0 == $# ]]; then
          set -- 'help'
          continue
        fi
        pacman --color auto -Ss $@
        return $?
        ;;
      file-search)
        shift
        if [[ 0 == $# ]]; then
          set -- 'help'
          continue
        fi
        if [[ ! -f /usr/bin/pkgfile ]]; then
          sudo pacman --noconfirm --color auto -S pkgfile
          pkgfile --update
        fi
        pkgfile --search $@
        return $?
        ;;
      generate-template)
        local template_file
        local list_of_packages
        shift
        if [[ 0 == $# ]]; then
          set -- 'help'
          continue
        fi
        template_file=$(readlink -f $1)
        template_file="$template_file.template"
        sudo -v
        echo "生成软件包列表（需要一会儿）"
        list_of_packages=$(pacman -Qqn)    # 这里不使用数组
        echo "生成$template_file"
        if [[ -e $template_file ]]; then
          rm -f $template_file
        fi
        echo $list_of_packages | sudo tee -a $template_file >/dev/null 2>&1
        return $?
        ;;
      install-template)
        local template_file
        local list_of_packages
        shift
        if [[ 0 == $# ]]; then
          set -- 'help'
          continue
        fi
        template_file=$(readlink -f $1)
        template_file="$template_file.template"
        if [[ ! -e $template_file ]]; then
          echo "文件$template_file 不存在。"
          return 1
        fi
        list_of_packages=( $(cat $template_file) )
        sudo pacman --needed --color auto -S ${list_of_packages[@]}
        return $?
        ;;
      remove-template)
        local template_file
        local list_of_packages
        shift
        if [[ 0 == $# ]]; then
          set -- 'help'
          continue
        fi
        template_file=$(readlink -f $1)
        template_file="$template_file.template"
        if [[ ! -e $template_file ]]; then
          echo "文件$template_file 不存在。"
          return 1
        fi
        list_of_packages=( $(cat $template_file) )
        sudo pacman --color auto -Rsn ${list_of_packages[@]}
        return $?
        ;;
      h|help|-h|--help)
        cat << END_OF_HELP
archpkg - Arch Linux 下slackpkg 风格的软件包管理器

用法:
  archpkg [选项] <匹配串|文件名>

选项:
  help                          显示本帮助
  update                        更新软件仓库
  check-updates [包名]          检查更新
  upgrade-all                   更新系统
  clean-system                  清理旧的软件包缓存
  install <包名>                安装软件包
  reinstall <包名>              重新安装软件包
  remove <正则表达式>           卸载软件包
  download <包名>               下载软件包但不安装
  info <包名>                   打印软件包信息
  search <正则表达式>           查找软件包
  file-search <文件名>          显示某文件属于哪个包
  generate-template <模板名>    生成包含软件包列表的模板文件
  install-template <模板名>     安装模板文件中记录的所有软件包
  remove-template <模板名>      删除模板文件中记录的所有软件包(永远不要使用!)

示例:
  archpkg upgrade-all
  archpkg file-search vim
  archpkg remove lib32-.+
END_OF_HELP
        return 1
        ;;
      *)
        echo "使用archpkg -h 查看帮助"
        return 1
    esac
  done
}


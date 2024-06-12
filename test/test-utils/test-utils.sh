#!/bin/bash

USERNAME=${1:-vscode}

FAILED=()

echoStderr() {
    echo "$@" 1>&2
}

check() {
    LABEL=$1
    shift
    echo -e "\n🧪 Testing $LABEL"
    if "$@"; then
        echo "✅  Passed!"
        return 0
    else
        echoStderr "❌ $LABEL check failed."
        FAILED+=("$LABEL")
        return 1
    fi
}

checkCommon() {
    check "non-root-user" id "${USERNAME}"
    check "www-data" groups "${USERNAME}"
    check "locale" [ "$(locale -a | grep en_US.utf8)" ]
    check "sudo" sudo echo "sudo works."
    check "zsh" zsh --version
    check "oh-my-zsh" [ -d "$HOME/.oh-my-zsh" ]
    check "login-shell-path" [ -f "/etc/profile.d/00-restore-env.sh" ]
    check "code" which code
}

reportResults() {
    if [ ${#FAILED[@]} -ne 0 ]; then
        echoStderr -e "\n💥  Failed tests: ${FAILED[@]}"
        exit 1
    else
        echo -e "\n💯  All passed!"
        exit 0
    fi
}

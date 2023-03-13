
# check the current git branch
function __git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# check the git status
function __git_status() {
  git status -s 2> /dev/null | awk '{print $1}' | tr '\n' ' '
}

# check if there are any untracked files
function __git_untracked() {
  git ls-files --others --exclude-standard 2> /dev/null | awk '{print "+"}' | tr -d '\n'
}

# check if there are any stashed files
function __git_stashed() {
  git stash list 2> /dev/null | awk '{print ":"}' | tr -d '\n'
}

# check if there are any ahead/behind commits
function __git_ahead_behind() {
  git rev-list --left-right --count HEAD...origin/master 2> /dev/null | awk '{print "{"$1" "$2"}"}'
}

# check if there are any unstaged changes in the current repository.
function __git_unstaged() {
  git diff --no-ext-diff --quiet --exit-code || echo "*"
}

# check if there are any merge conflicts in the current repository.
function __git_conflicts() {
  git ls-files --unmerged 2> /dev/null | awk '{print "!"}' | tr -d '\n'
}

# check if there are any staged changes in the current repository.
function __git_staged() {
  git diff --cached --no-ext-diff --quiet --exit-code || echo "+"
}
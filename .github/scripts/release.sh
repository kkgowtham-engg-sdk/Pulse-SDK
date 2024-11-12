

function merge_dev_to_master() {
    git checkout master
    git pull origin master
    git checkout development
    git pull origin development
    git merge master
    git checkout master
    git merge development
    git push origin master
}

function publish_packages() {
  melos bootstrap
  melos get
  melos publish --no-dry-run --git-tag-version --yes
  git push origin --tags
}

function merge_master_to_dev() {
  git checkout development
  git pull origin development
  git merge master
  git push origin development
}


merge_dev_to_master
publish_packages
merge_master_to_dev
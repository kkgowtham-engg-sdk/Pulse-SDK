#!/usr/bin/env kotlin

@file:Import("../../../sdk-automation-scripts/scripts/utils/git-utils.kt")
@file:Import("../../../sdk-automation-scripts/scripts/utils/common-utils.kt")

fun releasePlugins(){
    println("Merge development branch to master")
    mergeDevBranchToMaster()
    println("Publish plugins")
    executeCommandOnShell("melos publish --no-dry-run --git-tag-version --yes")
    println("Merge master branch to development")
    mergeMasterToDevBranch()
    println("Publish local tags")
    pushLocalTags()
    println("Published plugins")
}

releasePlugins()
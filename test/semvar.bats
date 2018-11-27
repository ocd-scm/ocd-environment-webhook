#!/usr/bin/env bats

@test "Test major bad first" {
    run bin/semver_ge.bash 1.1.1 2.2.2
    echo "status = ${status}"
    echo "output = ${output}"
    [ "$status" -ne "0" ]
}


@test "Test major good first" {
	run bin/semver_ge.bash 2.2.2 1.1.1
    echo "status = ${status}"
    echo "output = ${output}"
    [ "$status" -eq "0" ]
}

@test "Test major bad second" {
    run bin/semver_ge.bash 1.1.1 1.2.2
    echo "status = ${status}"
    echo "output = ${output}"
    [ "$status" -ne "0" ]
}

@test "Test major good second" {
	run bin/semver_ge.bash 1.2.2 1.1.1
    echo "status = ${status}"
    echo "output = ${output}"
    [ "$status" -eq "0" ]
}

@test "Test ignore third high" {
	run bin/semver_ge.bash 1.1.2 1.1.1
    echo "status = ${status}"
    echo "output = ${output}"
    [ "$status" -eq "0" ]
}

@test "Test ignore third low" {
	run bin/semver_ge.bash 1.1.1 1.1.2
    echo "status = ${status}"
    echo "output = ${output}"
    [ "$status" -eq "0" ]
}

@test "Test ignore traling letters" {
	run bin/semver_ge.bash 1.0.0-test 1.0.0
    echo "status = ${status}"
    echo "output = ${output}"
    [ "$status" -eq "0" ]
}
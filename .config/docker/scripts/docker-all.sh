#!/bin/bash

function print_help {

    local type="${1}"

    case "${type}" in
        containers | noautostart | stop | images | volumes | networks)
            return;;
        *)
            echo "Parameters: [type] [filter?] [debug?]"
            echo "Allowed types: containers, noautostart, stop, images, volumes, networks"
            exit 1
            ;;
    esac
}

function find_by_type_json {
    local type="${1}"

    case "${type}" in
        containers | noautostart | stop)
            docker ps --all --format=json | jq -s -c -M '[.[] | {ID, Name:.Names}]';;
        images)
            docker images --all --format=json | jq -s -c -M '[.[] | {ID, Name:(.Repository + ":" + .Tag)}]';;
        volumes)
            docker volume ls --format=json | jq -s -c -M '[.[] | {ID:.Name, Name:.Name}]';;
        networks)
            docker network ls --format=json | jq -s -c -M '[.[] | select(.Name != "bridge" and .Name != "host" and .Name != "none") | {ID,Name}]';;
        *)
            echo "[]";;
    esac
}

TYPE="${1:-None}"
FILTER="${2}"
DEBUG="${3}"

print_help "${TYPE}"

search_results=$(find_by_type_json "${TYPE}" | jq --arg filter "${FILTER}" '[.[] | select(.Name | contains($filter))]')
echo "${search_results}" | jq -r '.[] | .Name' | sort
readarray -t list <<< "$(echo "${search_results}" | jq -r '.[] | .ID')"

if [[ "${#list}" == 0 ]]; then
    exit 1
fi

if [[ -n "${DEBUG}" ]]; then
    exit 1
fi

echo ""
echo "Performing: ${TYPE}. Filter: ${FILTER}"
echo ""

read -p "Continue? " -n 1 -r 
echo ""
if [[ "${REPLY}" != "y" ]]; then
    echo "Cancelled"
    exit 1
fi


case "${TYPE}" in 
    stop)
        docker stop "${list[@]}"
        ;;
    containers)
        docker rm -f "${list[@]}"
        ;;
    images)
        docker rmi -f "${list[@]}"
        ;;
    volumes)
        docker volume rm "${list[@]}"
        ;;
    networks)
        docker network rm -f "${list[@]}"
        ;;
    noautostart)
        echo "${list[@]}" | xargs docker update --restart no
        ;;
    *)
        ;;
esac



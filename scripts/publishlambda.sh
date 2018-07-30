#Usage: ./publishlambda.sh LambdaFnName Alias
#Description: Creates a new version of lambda function and links it to alias
#Dependencies: jq, aws cli

YELLOW='\033[1;33m'
NC='\033[0m'

lambdaFnName=$1
linkToAlias=$2
logging=false

#check wether jq and aws cli is installed

command -v jq >/dev/null 2>&1 || { echo >&2 "The script requires jq. You can download it from https://stedolan.github.io/jq/"; exit 1; }
command -v aws >/dev/null 2>&1 || { echo >&2 "The script requires aws cli. You can download it from https://aws.amazon.com/cli/"; exit 1; }

echo "Publishing new version for lambda function ${YELLOW}$lambdaFnName${NC} and linking to alias ${YELLOW}$linkToAlias${NC}"

publish=`aws lambda publish-version --function-name $lambdaFnName`
echo "Published new version"

if $logging ; then
  echo "Publish logs $publish"
fi

echo "Getting lastest version for the function"
lastestVersion=`aws lambda list-versions-by-function --function-name $lambdaFnName | jq -r '.Versions[-1] | .Version'`

if $logging ; then
   echo "Latest version: $lastestVersion"
fi

#revId=`aws lambda get-function --function-name $lambdaFnName | jq -r '.Configuration.RevisionId'`
echo "Updating alias ${YELLOW}$linkToAlias${NC} to new version ${YELLOW}$latestVersion${NC}"
aliasResponse=`aws lambda update-alias --function-name $lambdaFnName --name $linkToAlias --function-version $lastestVersion`
echo "Linking to alias done."

if $logging ; then
  echo "Update alias logs: $aliasResponse"
fi


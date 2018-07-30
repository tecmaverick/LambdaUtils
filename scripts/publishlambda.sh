
YELLOW='\033[1;33m'
NC='\033[0m'

lambdaFnName=$1
linkToAlias=$2
logging=false

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


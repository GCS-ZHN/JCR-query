JOURNAL="Cell Reports"
YEAR=2021
COOKIE='请通过浏览器打开JCR查询页面，获取COOKIE并替换'
SID='同理获取请求头X-1P-INC-SID的内容并替换'
req=`curl -s -H 'Content-Type: application/json' -H "Cookie: $COOKIE" -H "X-1P-INC-SID: $SID" https://jcr.clarivate.com/api/jcr3/bwjournal/v1/search-suggestion?query=${JOURNAL/ /%20}|jq .data.journals[0]`
journalID=`echo $req|jq .journalName`
journalTitle=`echo $req|jq .title`
echo "Input \"$JOURNAL\", Matched journal: $journalTitle"
DATA="{\"journal\":$journalID,\"year\":\"$YEAR\",\"start\":1,\"limit\":\"200\"}"
citationCount=`curl -s -H 'Content-Type: application/json' -H "Cookie: $COOKIE" -H "X-1P-INC-SID: $SID" -d "$DATA" -X POST https://jcr.clarivate.com/api/jcr3/journalprofile/v1/jif-citing-journals|jq .citationCount`
totalCount=`curl -s -H 'Content-Type: application/json' -H "Cookie: $COOKIE" -H "X-1P-INC-SID: $SID" -d "$DATA" -X POST https://jcr.clarivate.com/api/jcr3/journalprofile/v1/jif-citable-items|jq .totalCount`
jcr_if=`echo "scale=3;$citationCount/$totalCount"|bc -q`
echo "IF of $journalTitle in $YEAR is $jcr_if, Citation is $citationCount, paper is $totalCount"

In Windows I use a small BAT with the help of UnxUtils:

SET TOKEN_BOT=XXXXXXXXXX:YYYYYYYYYYYYYY_ZZZZZZZZZZZZZZZZZZZZ
SET ID_CHAT=-000000000
SET URL=https://api.telegram.org/bot%TOKEN_BOT%/sendMessage
SET MESSAGE="Hello from my Windows"
curl -v -X POST --silent --output /dev/null %URL% -d chat_id=%ID_CHAT% -d text=%MESSAGE%

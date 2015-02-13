UPDATE  objectprotocol set protocoldata = REPLACE(protocoldata, '<Пользователь (корректировка)>', 'Пользователь (корректировка)') 
WHERE protocoldata LIKE '%<Пользователь (корректировка)>%'
UPDATE  objectprotocol set protocoldata = REPLACE(protocoldata, '<������������ (�������������)>', '������������ (�������������)') 
WHERE protocoldata LIKE '%<������������ (�������������)>%'
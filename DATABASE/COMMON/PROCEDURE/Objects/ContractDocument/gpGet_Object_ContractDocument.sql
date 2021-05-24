-- Function: gpGet_Object_ContractDocument()

DROP FUNCTION IF EXISTS gpGet_Object_ContractDocument(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ContractDocument(
IN inContractDocumentId  Integer,       /* Форма */
IN inSession             TVarChar       /* текущий пользователь */)
RETURNS TBlob AS
$BODY$
  DECLARE vbData   TBlob;
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
     vbUserId:= lpGetUserBySession (inSession);


   SELECT 
       ObjectBlob_ContractDocument_Data.ValueData INTO vbData
   FROM ObjectBLOB AS ObjectBlob_ContractDocument_Data
  WHERE ObjectBlob_ContractDocument_Data.DescId = zc_ObjectBlob_ContractDocument_Data() 
    AND ObjectBlob_ContractDocument_Data.ObjectId = inContractDocumentId;
    
   RETURN vbData; 
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.05.21                                        *
*/

-- тест
-- SELECT length(gpGet_Object_ContractDocument) FROM gpGet_Object_ContractDocument(1, '5')

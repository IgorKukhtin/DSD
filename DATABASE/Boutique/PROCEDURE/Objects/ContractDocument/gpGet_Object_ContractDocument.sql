-- Function: gpGet_Object_ContractDocument()

DROP FUNCTION IF EXISTS gpGet_Object_ContractDocument(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ContractDocument(
IN inContractDocumentId  Integer,       /* Форма */
IN inSession             TVarChar       /* текущий пользователь */)
RETURNS TBlob AS
$BODY$
DECLARE
  Data TBlob;
  UserId Integer;
BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   UserId := to_number(inSession, '00000000000');   

   SELECT 
       ObjectBlob_ContractDocument_Data.ValueData INTO Data
   FROM ObjectBLOB AS ObjectBlob_ContractDocument_Data
  WHERE ObjectBlob_ContractDocument_Data.DescId = zc_ObjectBlob_ContractDocument_Data() 
    AND ObjectBlob_ContractDocument_Data.ObjectId = inContractDocumentId;
    
   RETURN DATA; 
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpGet_Object_ContractDocument(Integer, TVarChar)
  OWNER TO postgres;

-- SELECT length(gpGet_Object_Form) FROM gpGet_Object_UserFormSettings('Form1', '2')
-- Function: gpGet_Movement_ComDoc()

DROP FUNCTION IF EXISTS gpGet_Movement_ComDoc(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ComDoc(
IN inMovementId          Integer,       /* Документ */
IN inSession             TVarChar       /* текущий пользователь */)
RETURNS TBlob AS
$BODY$
DECLARE
  Data TBlob;
  UserId Integer;
BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   SELECT 
       MovementBlob_ComDoc.ValueData INTO Data
   FROM MovementBLOB AS MovementBlob_ComDoc
  WHERE MovementBlob_ComDoc.DescId = zc_MovementBlob_ComDoc() 
    AND MovementBlob_ComDoc.MovementId = inMovementId;
    
   RETURN DATA; 
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpGet_Object_ContractDocument(Integer, TVarChar)
  OWNER TO postgres;

-- SELECT length(gpGet_Object_Form) FROM gpGet_Object_UserFormSettings('Form1', '2')
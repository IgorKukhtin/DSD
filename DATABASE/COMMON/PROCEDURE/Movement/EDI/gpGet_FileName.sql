-- Function: gpGet_FileName()

DROP FUNCTION IF EXISTS gpGet_FileName(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_FileName(
IN inMovementId          Integer,       /* Документ */
OUT outFileName          TVarChar, 
IN inSession             TVarChar       /* текущий пользователь */)
RETURNS TVarChar AS
$BODY$
DECLARE
  UserId Integer;
BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   SELECT 
       MovementString_FileName.ValueData INTO outFileName
   FROM MovementString AS MovementString_FileName
  WHERE MovementString_FileName.DescId = zc_MovementString_FileName() 
    AND MovementString_FileName.MovementId = inMovementId;
      
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpGet_FileName(Integer, TVarChar)
  OWNER TO postgres;

-- SELECT length(gpGet_Object_Form) FROM gpGet_Object_UserFormSettings('Form1', '2')
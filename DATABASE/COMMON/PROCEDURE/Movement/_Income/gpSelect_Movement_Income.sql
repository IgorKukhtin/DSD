-- Function: gpSelect_Movement_Income()

--DROP FUNCTION gpSelect_Movement_Income();

CREATE OR REPLACE FUNCTION gpSelect_Movement_Income(
IN inStartDate   TDateTime,
IN inEndDate     TDateTime,
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT 
     Movement.Id,
    1, cast('fggg' AS TVarChar) , true
   FROM Movement
   WHERE Movement.DescId = zc_Movement_Income();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Movement_Income(TDateTime, TDateTime, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_Movement_Income('2')
-- Function: gpSelect_Movement_OrderClient_Info()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderClient_Info (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderClient_Info(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer
             , CodeInfo Integer, DescInfo TVarChar, Text_Info TBlob
             
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderClient());
     vbUserId := inSession;

     
      RETURN QUERY

        SELECT 
            Movement_OrderClient.Id
          , zfConvert_StringToNumber (Movement_OrderClient.InvNumber) ::Integer AS InvNumber
          , 1 ::Integer AS CodeInfo
          , 'Information  1' ::TVarChar AS DescInfo
          , CASE WHEN TRIM (COALESCE (MovementBlob_Info.ValueData,'')) = '' THEN CHR (13) || CHR (13) || CHR (13) ELSE MovementBlob_Info.ValueData END :: TBlob AS Text_Info

        FROM Movement AS Movement_OrderClient 
            LEFT JOIN MovementBlob AS MovementBlob_Info
                                   ON MovementBlob_Info.MovementId = Movement_OrderClient.Id
                                  AND MovementBlob_Info.DescId = zc_MovementBlob_Info1()
        WHERE Movement_OrderClient.Id = inMovementId
          AND Movement_OrderClient.DescId = zc_Movement_OrderClient()
          --AND COALESCE (MovementBlob_Info.ValueData,'') <> ''
      UNION 
        SELECT 
            Movement_OrderClient.Id
          , zfConvert_StringToNumber (Movement_OrderClient.InvNumber) ::Integer AS InvNumber
          , 2 ::Integer AS CodeInfo
          , 'Information  2' ::TVarChar AS DescInfo
          , CASE WHEN TRIM (COALESCE (MovementBlob_Info.ValueData,'')) = '' THEN CHR (13) || CHR (13) || CHR (13) ELSE MovementBlob_Info.ValueData END :: TBlob AS Text_Info

        FROM Movement AS Movement_OrderClient 
            LEFT JOIN MovementBlob AS MovementBlob_Info
                                   ON MovementBlob_Info.MovementId = Movement_OrderClient.Id
                                  AND MovementBlob_Info.DescId = zc_MovementBlob_Info2()
        WHERE Movement_OrderClient.Id = inMovementId
          AND Movement_OrderClient.DescId = zc_Movement_OrderClient()
          --AND COALESCE (MovementBlob_Info.ValueData,'') <> ''
      UNION 
        SELECT 
            Movement_OrderClient.Id
          , zfConvert_StringToNumber (Movement_OrderClient.InvNumber) ::Integer AS InvNumber
          , 3 ::Integer AS CodeInfo
          , 'Information  3' ::TVarChar AS DescInfo
          , CASE WHEN TRIM (COALESCE (MovementBlob_Info.ValueData,'')) = '' THEN CHR (13) || CHR (13) || CHR (13) ELSE MovementBlob_Info.ValueData END :: TBlob AS Text_Info

        FROM Movement AS Movement_OrderClient 
            LEFT JOIN MovementBlob AS MovementBlob_Info
                                   ON MovementBlob_Info.MovementId = Movement_OrderClient.Id
                                  AND MovementBlob_Info.DescId = zc_MovementBlob_Info3()
        WHERE Movement_OrderClient.Id = inMovementId
          AND Movement_OrderClient.DescId = zc_Movement_OrderClient()
          --AND COALESCE (MovementBlob_Info.ValueData,'') <> ''

          ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.02.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderClient_Info (inMovementId:= 75, inSession:= '5')

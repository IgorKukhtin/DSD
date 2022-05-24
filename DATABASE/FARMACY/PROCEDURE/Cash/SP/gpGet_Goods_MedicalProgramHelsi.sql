-- Function: gpGet_Goods_MedicalProgramHelsi()

  DROP FUNCTION IF EXISTS gpGet_Goods_MedicalProgramHelsi (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Goods_MedicalProgramHelsi(
    IN inGoodsId           Integer  ,  --
    IN inMedicalProgramId  TVarChar ,  --
   OUT outIdSP             TVarChar ,  --
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;


    SELECT  MIString_IdSP.ValueData       AS IdSP
    INTO outIdSP
    FROM Movement
         INNER JOIN MovementDate AS MovementDate_OperDateStart
                                 ON MovementDate_OperDateStart.MovementId = Movement.Id
                                AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                AND MovementDate_OperDateStart.ValueData  <= CURRENT_DATE

         INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                 ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                AND MovementDate_OperDateEnd.ValueData  >= CURRENT_DATE

         INNER JOIN MovementLinkObject AS MLO_MedicalProgramSP
                                       ON MLO_MedicalProgramSP.MovementId = Movement.Id
                                      AND MLO_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
         INNER JOIN ObjectString AS ObjectString_ProgramId 	
                                 ON ObjectString_ProgramId.ObjectId = MLO_MedicalProgramSP.ObjectId
                                AND ObjectString_ProgramId.DescId = zc_ObjectString_MedicalProgramSP_ProgramId()
                               
         INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                AND MovementItem.DescId     = zc_MI_Master()
                                AND MovementItem.isErased   = FALSE
                                AND MovementItem.ObjectId   = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.ID = inGoodsId)

         -- ID лікарського засобу
         LEFT JOIN MovementItemString AS MIString_IdSP
                                      ON MIString_IdSP.MovementItemId = MovementItem.Id
                                     AND MIString_IdSP.DescId = zc_MIString_IdSP()

    WHERE Movement.DescId = zc_Movement_GoodsSP()
      AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
      AND ObjectString_ProgramId.ValueData = inMedicalProgramId
    ORDER BY Movement.OperDate DESC
    LIMIT 1;
                            

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.05.22                                                       *
*/

-- тест
-- 

SELECT * FROM gpGet_Goods_MedicalProgramHelsi (inGoodsId := 16103188, inMedicalProgramId := '8efe29df-18bd-4d49-8995-c3f7e44d9e12', inSession:= '3')
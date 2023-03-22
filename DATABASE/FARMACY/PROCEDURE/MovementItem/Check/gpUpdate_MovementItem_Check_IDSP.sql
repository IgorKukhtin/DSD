 -- Function: gpUpdate_MovementItem_Check_IDSP()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Check_IDSP (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Check_IDSP(
    IN inId                  Integer   , -- Ключ объекта <строка документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inMedicalProgramSPId  Integer   , -- Медицинская программа
    IN inAmount              TFloat    , -- Количество
    IN inQty                 TFloat    , -- Количество погашено по рецепту
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE IdSP TVarChar;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);
    
    IF COALESCE (inId, 0) = 0
    THEN
      RETURN;
    END IF;

    IF EXISTS(SELECT * FROM MovementItemString 
              WHERE MovementItemString.DescId = zc_MIString_IdSP() 
                AND MovementItemString.MovementItemId = inId
                AND COALESCE (MovementItemString.ValueData, '') <> '')
    THEN
      RETURN;
    END IF;
    
    
    -- сеть пользователя
    vbObjectId := COALESCE (lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');
    
    vbOperDate := (SELECT date_trunc('DAY', Movement.OperDate)
                   FROM Movement 
                   WHERE Movement.Id = inMovementId);    
    
    CREATE TEMP TABLE tmpGoodsSP ON COMMIT DROP AS 
    SELECT MovementItem.ObjectId         AS GoodsId
         , MIFloat_CountSP.ValueData     AS CountSP
         , MIString_IdSP.ValueData       AS IdSP
    FROM Movement
         INNER JOIN MovementDate AS MovementDate_OperDateStart
                                 ON MovementDate_OperDateStart.MovementId = Movement.Id
                                AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                AND MovementDate_OperDateStart.ValueData  <= vbOperDate

         INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                 ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                AND MovementDate_OperDateEnd.ValueData  >= vbOperDate

         LEFT JOIN MovementLinkObject AS MLO_MedicalProgramSP
                                      ON MLO_MedicalProgramSP.MovementId = Movement.Id
                                     AND MLO_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
                               
         LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                               AND MovementItem.DescId     = zc_MI_Master()
                               AND MovementItem.isErased   = FALSE
                               
         LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = MovementItem.ObjectId
                                      AND Object_Goods_Retail.RetailId = vbObjectId 


         -- Кількість одиниць лікарського засобу у споживчій упаковці (Соц. проект)(6)
         LEFT JOIN MovementItemFloat AS MIFloat_CountSP
                                     ON MIFloat_CountSP.MovementItemId = MovementItem.Id
                                    AND MIFloat_CountSP.DescId = zc_MIFloat_CountSP()

         -- ID лікарського засобу
         LEFT JOIN MovementItemString AS MIString_IdSP
                                      ON MIString_IdSP.MovementItemId = MovementItem.Id
                                     AND MIString_IdSP.DescId = zc_MIString_IdSP()

    WHERE Movement.DescId = zc_Movement_GoodsSP()
      AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
      AND MLO_MedicalProgramSP.ObjectId = inMedicalProgramSPId
      AND Object_Goods_Retail.Id = inGoodsId
      ;
      
    ANALYSE tmpGoodsSP;
    
    IF (SELECT count(*) FROM tmpGoodsSP) = 1
    THEN
      IdSP := (SELECT tmpGoodsSP.IdSP FROM tmpGoodsSP);
    ELSEIF (SELECT count(*) FROM tmpGoodsSP WHERE Round(inQty / tmpGoodsSP.CountSP, 2) = Round(inAmount, 2)) = 1
    THEN
      IdSP := (SELECT tmpGoodsSP.IdSP FROM tmpGoodsSP WHERE Round(inQty / tmpGoodsSP.CountSP, 2) = Round(inAmount, 2));
    ELSE
      IdSP := Null;
    END IF;
    
    raise notice 'Value 6: % %', vbOperDate, IdSP;

    -- сохранили свойство <ID лікар. засобу для СП>
    IF COALESCE(Trim(IdSP), '') <> ''
    THEN
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_IdSP(), inId, Trim(IdSP));
    END IF;

  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpUpdate_MovementItem_Check_IDSP (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Шаблий О.В.
 06.10.18       *
*/

select * from gpUpdate_MovementItem_Check_IDSP(inId := 583741585 , inMovementId := 31409684 , inGoodsId := 25546 , inMedicalProgramSPId := 18078197 , inAmount := 1.2 , inQty := 18 ,  inSession := '3');


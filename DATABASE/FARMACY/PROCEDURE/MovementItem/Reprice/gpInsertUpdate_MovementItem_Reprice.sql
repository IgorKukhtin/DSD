-- Function: gpInsert_MovementItem_Reprice()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Reprice (Integer, Integer, Integer, Integer, TFloat, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat,TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Reprice(
 INOUT ioId                  Integer   , -- Ключ записи
    IN inGoodsId             Integer   , -- Товары
    IN inUnitId              Integer   , -- подразделение
    IN inUnitId_Forwarding   Integer   , -- Подразделения(основание для равенства цен)
    IN inTax                 TFloat    , -- % +/-
    IN inJuridicalId         Integer   , -- поставщик
    IN inContractId          Integer   , -- Договор
    IN inExpirationDate      TDateTime , -- Срок годности 
    IN inMinExpirationDate   TDateTime , -- Срок годности остатка
    IN inAmount              TFloat    , -- Количество (Остаток)
    IN inPriceOld            TFloat    , -- Цена старая
    IN inPriceNew            TFloat    , -- Цена новая
    IN inJuridical_Price     TFloat    , -- Цена поставщика
    IN inJuridical_Percent   TFloat    , -- % Корректировки наценки поставщика
    IN inContract_Percent    TFloat    , -- % Корректировки наценки Договора
    IN inGUID                TVarChar  , -- GUID для определения текущей переоценки
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer 
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    
    -- !!!Протокол - отладка Скорости!!!
    vbOperDate_StartBegin:= CLOCK_TIMESTAMP();

    
    if inSession = '183242'
    and inUnitId               = 377610
    and inUnitId_Forwarding   = 0
-- "158202773,27814,377610,0,0,59612,183378,'01.03.2020','01.02.2020',1,22.7,23.3,21.36,0,0,'{DA9C7F18-8308-46F3-A62E-9B5BBD353D15}','183242'"
    and 1=0
    then
       vbMovementId:= 9137080;
    else
    
    -- найти документ
    vbMovementId:= (SELECT Movement.Id
                    FROM Movement 
                        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                     AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()
                                                     AND MovementLinkObject_Unit.ObjectId   = inUnitId
                        INNER JOIN MovementString AS MovementString_GUID
                                                  ON MovementString_GUID.MovementId = Movement.Id
                                                 AND MovementString_GUID.DescId     = zc_MovementString_Comment()
                                                 AND MovementString_GUID.ValueData  = inGUID
                    WHERE Movement.DescId  = zc_Movement_Reprice()
                      -- AND Movement.OperDate >= CURRENT_DATE AND Movement.OperDate < CURRENT_DATE + INTERVAL '1 DAY'
                      AND Movement.OperDate = CURRENT_DATE
                   );
end if;        

    IF COALESCE (vbMovementId, 0) = 0
    THEN
        -- 
        vbMovementId := lpInsertUpdate_Movement_Reprice(ioId        := COALESCE (vbMovementId,0),
                                                        inInvNumber := CAST (NEXTVAL('movement_sale_seq') AS TVarChar),
                                                        inOperDate  := CURRENT_DATE::TDateTime,
                                                        inUnitId    := inUnitId,
                                                        inGUID      := inGUID,
                                                        inUserId    := vbUserId);
        -- сохранили связь с <Подразделения(основание для равенства цен)>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UnitForwarding(), vbMovementId, inUnitId_Forwarding);
        -- сохранили <(-)% Скидки (+)% Наценки (основание для равенства цен)>
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), vbMovementId, inTax);
       

    ELSE 
        -- сохранили связь с <Подразделения(основание для равенства цен)>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UnitForwarding(), vbMovementId, inUnitId_Forwarding);
        -- сохранили <(-)% Скидки (+)% Наценки (основание для равенства цен)>
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), vbMovementId, inTax);

    END IF;

    -- переоценить товар
    PERFORM lpInsertUpdate_Object_Price(inGoodsId := inGoodsId,
                                        inUnitId  := inUnitId,
                                        inPrice   := inPriceNew,
                                        inDate    := CURRENT_DATE::TDateTime,
                                        inUserId  := vbUserId);

    -- сохранить запись
    ioId := lpInsertUpdate_MovementItem_Reprice (ioId                 := COALESCE(ioId,0)
                                               , inMovementId         := vbMovementId
                                               , inGoodsId            := inGoodsId
                                               , inJuridicalId        := inJuridicalId
                                               , inContractId         := inContractId
                                               , inExpirationDate  := inExpirationDate
                                               , inMinExpirationDate  := inMinExpirationDate
                                               , inAmount             := inAmount
                                               , inPriceOld           := inPriceOld
                                               , inPriceNew           := inPriceNew
                                               , inJuridical_Price    := inJuridical_Price
                                               , inJuridical_Percent  := inJuridical_Percent
                                               , inContract_Percent   := inContract_Percent
                                               , inUserId             := vbUserId);

    -- if inSession = zfCalc_UserAdmin() then 
    --
    -- !!!Протокол - отладка Скорости!!!
    INSERT INTO Log_Reprice (InsertDate, StartDate, EndDate, MovementId, UserId, TextValue)
      VALUES (CURRENT_TIMESTAMP, vbOperDate_StartBegin, CLOCK_TIMESTAMP(), vbMovementId, vbUserId
            , ioId                  :: TVarChar
    || ',' || inGoodsId             :: TVarChar
    || ',' || inUnitId              :: TVarChar
    || ',' || inUnitId_Forwarding   :: TVarChar
    || ',' || zfConvert_FloatToString (inTax)
    || ',' || inJuridicalId         :: TVarChar
    || ',' || inContractId          :: TVarChar
    || ',' || CHR (39) || zfConvert_DateToString (inExpirationDate)    || CHR (39)
    || ',' || CHR (39) || zfConvert_DateToString (inMinExpirationDate) || CHR (39)
    || ',' || zfConvert_FloatToString (inAmount)
    || ',' || zfConvert_FloatToString (inPriceOld)
    || ',' || zfConvert_FloatToString (inPriceNew)
    || ',' || zfConvert_FloatToString (inJuridical_Price)
    || ',' || zfConvert_FloatToString (inJuridical_Percent)
    || ',' || zfConvert_FloatToString (inContract_Percent)
    || ',' || CHR (39) || inGUID    || CHR (39)
    || ',' || CHR (39) || inSession || CHR (39)
             );
    -- end If;

    /*if inSession = zfCalc_UserAdmin() then 
      RAISE EXCEPTION ' %  %', vbOperDate_StartBegin, CLOCK_TIMESTAMP();
    end If;*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MovementItem_Reprice (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.
 18.02.16         *
 27.11.15                                                                       *
*/
--select * from gpInsertUpdate_MovementItem_Reprice(ioID := 0 , inGoodsId := 749444 , inUnitId := 4135547 , inUnitId_Forwarding := 183292 , inTax := 0 , inJuridicalId := 59610 , inContractId := 183257 , inExpirationDate := ('01.12.2022')::TDateTime , inMinExpirationDate := ('01.12.2022')::TDateTime , inAmount := 1 , inPriceOld := 20 , inPriceNew := 19.2 , inJuridical_Price := 18.3291 , inJuridical_Percent := 0 , inContract_Percent := 0 , inGUID := '{D56FDAB5-2E8B-4BB6-AC30-549410FF9EC0}' ,  inSession := '3');
--select * from gpSelect_AllGoodsPrice(inUnitId := 4135547 , inUnitId_to := 183292 , inMinPercent := 30 , inVAT20 := 'False' , inTaxTo := 0 , inPriceMaxTo := 0 ,  inSession := '3');
--select * from gpInsertUpdate_MovementItem_Reprice(ioID := 0 , inGoodsId := 28894 , inUnitId := 4135547 , inUnitId_Forwarding := 183292 , inTax := 0 , inJuridicalId := 59610 , inContractId := 183257 , inExpirationDate := ('01.07.2020')::TDateTime , inMinExpirationDate := ('01.12.2019')::TDateTime , inAmount := 1 , inPriceOld := 103.2 , inPriceNew := 102.6 , inJuridical_Price := 95.3263 , inJuridical_Percent := 0 , inContract_Percent := 0 , inGUID := '{603F0E68-F94C-4D93-BB24-F0778553C417}' ,  inSession := '3');

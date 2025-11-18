-- Function: gpInsertUpdate_MovementItem_OrderFinance()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderFinance (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderFinance (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderFinance(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inJuridicalId           Integer   , --
    IN inContractId            Integer   , --
    --IN inBankAccountId         Integer   , --
    IN inAmount                TFloat    , --
    ---IN inAmountStart           TFloat    , --
    IN inAmountPlan_1          TFloat    , --
    IN inAmountPlan_2          TFloat    , --
    IN inAmountPlan_3          TFloat    , --
    IN inAmountPlan_4          TFloat    , --
    IN inAmountPlan_5          TFloat    , --
   OUT outAmountPlan_total     TFloat    , --
    IN inisAmountPlan_1        Boolean    , --
    IN inisAmountPlan_2        Boolean    , --
    IN inisAmountPlan_3        Boolean    , --
    IN inisAmountPlan_4        Boolean    , --
    IN inisAmountPlan_5        Boolean    , --
    IN inComment               TVarChar  , --
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderFinance());

     -- сохранили
     SELECT tmp.ioId
            INTO ioId
     FROM lpInsertUpdate_MovementItem_OrderFinance (ioId              := ioId
                                                  , inMovementId      := inMovementId
                                                  , inJuridicalId     := inJuridicalId
                                                  , inContractId      := inContractId
                                                  , inAmount          := inAmount
                                                  , inAmountPlan_1    := inAmountPlan_1
                                                  , inAmountPlan_2    := inAmountPlan_2
                                                  , inAmountPlan_3    := inAmountPlan_3
                                                  , inAmountPlan_4    := inAmountPlan_4
                                                  , inAmountPlan_5    := inAmountPlan_5
                                                  , inisAmountPlan_1  := inisAmountPlan_1
                                                  , inisAmountPlan_2  := inisAmountPlan_2
                                                  , inisAmountPlan_3  := inisAmountPlan_3
                                                  , inisAmountPlan_4  := inisAmountPlan_4
                                                  , inisAmountPlan_5  := inisAmountPlan_5
                                                  , inComment         := inComment
                                                  , inUserId          := vbUserId
                                                   ) AS tmp;

    --
    outAmountPlan_total:= COALESCE (inAmountPlan_1, 0)
                        + COALESCE (inAmountPlan_2, 0)
                        + COALESCE (inAmountPlan_3, 0)
                        + COALESCE (inAmountPlan_4, 0)
                        + COALESCE (inAmountPlan_5, 0)
                       ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.02.21         * inAmountStart
 29.07.19         *
*/

-- тест
--
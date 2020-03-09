 -- Function: lpCheck_Movement_ReturnIn_Auto()

DROP FUNCTION IF EXISTS lpCheck_Movement_ReturnIn_Auto (Integer, Integer);

CREATE OR REPLACE FUNCTION lpCheck_Movement_ReturnIn_Auto(
    IN inMovementId          Integer   , -- ключ Документа
   OUT outMessageText        Text      ,
    IN inUserId              Integer     -- Пользователь
)
RETURNS Text
AS
$BODY$
   DECLARE vbMovementDescId Integer;
BEGIN

     -- !!!для ВСЕХ кладовщиков - выход!!! + убрал zc_Enum_Process_Auto_PrimeCost
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View
                WHERE UserId = inUserId
                  AND RoleId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Role() AND Object.ObjectCode IN (3004, 4004, 5004, 6004, 7004, 8004, 8014, 9004))
               )
        -- OR inUserId IN (zc_Enum_Process_Auto_PrimeCost())
     THEN
         outMessageText:= '-1';
         RETURN;
     END IF;

     -- !!!для НАЛ - обнуление и выход!!!
     IF zc_Enum_PaidKind_SecondForm() = (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindFrom()))
    AND inUserId <> zc_Enum_Process_Auto_ReturnIn()
    AND inUserId > 0
     THEN
         -- !!!ВРЕМЕННО - НИЧЕГО НЕ ДЕЛАЕМ!!!
         -- !!!обнуление и выход!!!
         /*PERFORM lpInsertUpdate_MovementItem_ReturnIn_Child (ioId                  := MovementItem.Id
                                                           , inMovementId          := inMovementId
                                                           , inParentId            := MovementItem.ParentId
                                                           , inGoodsId             := MovementItem.ObjectId
                                                           , inAmount              := 0
                                                           , inMovementId_sale     := 0
                                                           , inMovementItemId_sale := 0
                                                           , inUserId              := ABS (inUserId)
                                                           , inIsRightsAll         := FALSE
                                                            )
         FROM MovementItem
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId     = zc_MI_Child()
        ;*/
         -- выход
         RETURN;
     END IF;


     -- Документ
     vbMovementDescId:= (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId);

     -- !!!временно, только для ТЕСТА!!!
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem'))
     THEN
         -- таблица
         CREATE TEMP TABLE _tmpItem (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, OperCount TFloat, OperCount_Partner TFloat, Price_original TFloat, isErased Boolean)  ON COMMIT DROP;
         -- Данные
         INSERT INTO _tmpItem (MovementItemId, GoodsId, GoodsKindId, OperCount, OperCount_Partner, Price_original, isErased)
                 SELECT MI.Id AS MovementItemId, MI.ObjectId AS GoodsId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                      , CASE WHEN Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_PriceCorrective()) THEN 0 ELSE MI.Amount END AS OperCount
                      , CASE WHEN Movement.DescId = zc_Movement_ReturnIn()        THEN MIF_AmountPartner.ValueData
                             WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN MI.Amount
                             ELSE 0
                        END AS OperCount_Partner
                      , COALESCE (CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN MIF_PriceTax_calc.ValueData ELSE MIF_Price.ValueData END, 0) AS Price_original
                      , MI.isErased
                 FROM MovementItem AS MI
                      LEFT JOIN Movement ON Movement.Id = MI.MovementId
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind ON MILinkObject_GoodsKind.MovementItemId = MI.Id AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      LEFT JOIN MovementItemFloat AS MIF_AmountPartner ON MIF_AmountPartner.MovementItemId = MI.Id AND MIF_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                      LEFT JOIN MovementItemFloat AS MIF_Price ON MIF_Price.MovementItemId = MI.Id AND MIF_Price.DescId = zc_MIFloat_Price()
                      LEFT JOIN MovementItemFloat AS MIF_PriceTax_calc ON MIF_PriceTax_calc.MovementItemId = MI.Id AND MIF_PriceTax_calc.DescId = zc_MIFloat_PriceTax_calc()
                 WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE
                   AND (CASE WHEN Movement.DescId <> zc_Movement_ReturnIn()        THEN MI.Amount                   ELSE 0 END <> 0
                     OR CASE WHEN Movement.DescId =  zc_Movement_ReturnIn()        THEN MIF_AmountPartner.ValueData ELSE 0 END <> 0
                       );
     /*ELSE 
         DELETE FROM _tmpItem;
         INSERT INTO _tmpItem (MovementItemId, GoodsId, GoodsKindId, OperCount_Partner, Price_original) SELECT MI.Id AS MovementItemId, MI.ObjectId AS GoodsId, COALESCE (MILO.ObjectId, 0) AS GoodsKindId, MIF1.ValueData AS OperCount_Partner, MIF.ValueData AS Price_original FROM MovementItem AS MI LEFT JOIN MovementItemLinkObject AS MILO ON MILO.MovementItemId = MI.Id AND MILO.DescId = zc_MILinkObject_GoodsKind() LEFT JOIN MovementItemFloat AS MIF1 ON MIF1.MovementItemId = MI.Id AND MIF1.DescId = zc_MIFloat_AmountPartner() LEFT JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_Price() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE;
     */
     END IF;
     -- !!!временно, только для ТЕСТА!!!


     -- !!!вернули ОШИБКУ, если есть!!!
     outMessageText:= (WITH tmpChild_all AS (SELECT MovementItem.ParentId, MovementItem.ObjectId AS GoodsId, SUM (MovementItem.Amount) AS Amount
                                             FROM MovementItem
                                             WHERE MovementItem.MovementId = inMovementId
                                               AND MovementItem.DescId     = zc_MI_Child()
                                               AND MovementItem.isErased   = FALSE
                                             GROUP BY MovementItem.ParentId, MovementItem.ObjectId
                                         )
                          , tmpChild AS (SELECT COALESCE (_tmpItem.MovementItemId, 0)             AS ParentId
                                              , COALESCE (_tmpItem.GoodsId, tmpChild_all.GoodsId) AS GoodsId
                                              , _tmpItem.GoodsKindId
                                              , _tmpItem.Price_original
                                              , tmpChild_all.Amount
                                         FROM tmpChild_all
                                              LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = tmpChild_all.ParentId
                                         )
                          , tmpResult AS (SELECT tmp.GoodsId, tmp.GoodsKindId, tmp.Price_original, SUM (tmp.Amount) AS Amount
                                          FROM tmpChild AS tmp
                                          GROUP BY tmp.GoodsId, tmp.GoodsKindId, tmp.Price_original
                                         )
                          , tmpMaster AS (SELECT tmp.GoodsId, tmp.GoodsKindId, tmp.Price_original
                                               , SUM (CASE WHEN vbMovementDescId IN (zc_Movement_ReturnIn(), zc_Movement_PriceCorrective())
                                                           THEN tmp.OperCount_Partner
                                                           ELSE tmp.OperCount
                                                      END) AS Amount
                                          FROM _tmpItem AS tmp
                                          WHERE COALESCE (tmp.isErased, FALSE) = FALSE
                                          GROUP BY tmp.GoodsId, tmp.GoodsKindId, tmp.Price_original
                                         UNION ALL
                                          SELECT -1 * tmp.GoodsId, 0 AS GoodsKindId, 0 AS Price_original, -1 * tmp.Amount AS Amount
                                          FROM tmpChild AS tmp
                                          WHERE tmp.Amount <> 0 AND tmp.ParentId = 0
                                         )
                       -- РЕЗУЛЬТАТ
                       SELECT 'Ошибка. Для возврата кол-во = <' || COALESCE (tmpMaster.Amount, 0) :: TVarChar || '>'
               || CHR (13) || 'не соответствует привязка к продаже с кол-во = <' || COALESCE (tmpResult.Amount, 0) :: TVarChar || '>.'
               || CHR (13) || 'Товар <' || lfGet_Object_ValueData (ABS (COALESCE (tmpMaster.GoodsId, tmpResult.GoodsId))) || '>'
                           || CASE WHEN COALESCE (tmpMaster.GoodsKindId, tmpResult.GoodsKindId) > 0 THEN CHR (13) || 'вид <' || lfGet_Object_ValueData_sh (COALESCE (tmpMaster.GoodsKindId, tmpResult.GoodsKindId)) || '>' ELSE '' END
                || CHR (13) || 'Цена <' || zfConvert_FloatToString (tmpMaster.Price_original) || '>'
                       FROM tmpMaster
                            FULL JOIN tmpResult ON tmpResult.GoodsId         = tmpMaster.GoodsId
                                               AND tmpResult.GoodsKindId     = tmpMaster.GoodsKindId
                                               AND tmpResult.Price_original  = tmpMaster.Price_original
                       WHERE COALESCE (tmpMaster.Amount, 0) <> COALESCE (tmpResult.Amount, 0)
                         AND COALESCE (tmpMaster.Price_original, -12345.0) <> 0
                       LIMIT 1
                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.05.16                                        *
*/

-- тест
-- SELECT * FROM MovementItem WHERE MovementId = 3662505 AND DescId = zc_MI_Child() -- SELECT * FROM MovementItemFloat WHERE MovementItemId IN (SELECT Id FROM MovementItem WHERE MovementId = 3662505 AND DescId = zc_MI_Child())
-- SELECT lpCheck_Movement_ReturnIn_Auto (inMovementId:= Movement.Id, inUserId:= zfCalc_UserAdmin() :: Integer) || CHR (13), Movement.* FROM Movement WHERE Movement.Id = 3662505
-- SELECT lpCheck_Movement_ReturnIn_Auto (inMovementId:= Movement.Id, inUserId:= zfCalc_UserAdmin() :: Integer) || CHR (13), Movement.* FROM Movement WHERE Movement.Id = 3185773 

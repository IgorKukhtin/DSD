 -- Function: gpUpdate_MI_ProductionUnion_ReceiptParam()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionUnion_ReceiptParam (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionUnion_ReceiptParam(
    IN inStartDate            TDateTime , --
    IN inEndDate              TDateTime , --
    IN inFromId               Integer   , -- От кого (в документе)
    IN inToId                 Integer   , -- Кому (в документе)
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession); --lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnionTech());


   -- !!!Проверка закрытия периода только для <Технолог Днепр>!!!
   IF EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND RoleId = 439522) -- Технолог Днепр
   THEN
       IF  (SELECT gpGet.OperDate FROM gpGet_Scale_OperDate (FALSE, 1, inSession) AS gpGet) > inStartDate
        OR (SELECT gpGet.OperDate FROM gpGet_Scale_OperDate (FALSE, 1, inSession) AS gpGet) > inEndDate
       THEN
           RAISE EXCEPTION 'Ошибка.Период закрыт до <%>.', DATE ((SELECT gpGet.OperDate FROM gpGet_Scale_OperDate (FALSE, 1, inSession) AS gpGet));
       END IF;
   END IF;

   -- Проверка для ЦЕХ колбаса+дел-сы
   IF (inFromId <> inToId) OR (NOT EXISTS (SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS lfSelect WHERE lfSelect.UnitId = inFromId)
                           -- AND inFromId <> 951601 -- ЦЕХ упаковки мясо
                           AND inFromId <> 981821   -- ЦЕХ шприц. мясо
                           AND inFromId <> 2790412  -- ЦЕХ Тушенка
                           AND inFromId <> 8020711  -- ЦЕХ колбаса + деликатесы (Ирна)
                              )
   THEN
       RAISE EXCEPTION 'Ошибка.Изменения возможны только для подазделений <%>.', lfGet_Object_ValueData (8446);
   END IF;

   -- таблица элементы Child
   CREATE TEMP TABLE _tmpChild (MovementItemId Integer, AmountReceipt TFloat, isWeightMain Boolean, isTaxExit Boolean) ON COMMIT DROP;
   --
       WITH 
        tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                       )
      -- все док. за период
     , _tmpMovement AS (SELECT Movement.Id
                        FROM Movement 
                             INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
              
                             INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                           ON MovementLinkObject_From.MovementId = Movement.Id
                                                          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                          AND MovementLinkObject_From.ObjectId = inFromId
              
                             INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                           ON MovementLinkObject_To.MovementId = Movement.Id
                                                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                          AND MovementLinkObject_To.ObjectId = inToId
                        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                          AND Movement.DescId = zc_Movement_ProductionUnion()
                       )
       
     , tmpMI_Master AS (SELECT MovementItem.MovementId AS MovementId
                             , MovementItem.Id         AS MovementItemId
                             , MILO_Receipt.ObjectId   AS ReceiptId
                        FROM _tmpMovement
                             INNER JOIN MovementItem ON MovementItem.MovementId = _tmpMovement.Id
                                                    AND MovementItem.DescId   = zc_MI_Master()
                                                    AND MovementItem.isErased = FALSE
                             INNER JOIN MovementItemLinkObject AS MILO_Receipt
                                                               ON MILO_Receipt.MovementItemId = MovementItem.Id
                                                              AND MILO_Receipt.DescId = zc_MILinkObject_Receipt()
                                                              AND COALESCE (MILO_Receipt.ObjectId, 0) <> 0
                        )

     , tmpMI_Child AS (SELECT MovementItem.Id                       AS MovementItemId_Child
                            , MovementItem.ParentId                 AS MovementItemId
                            , tmpMI_Master.ReceiptId                AS ReceiptId
                            , MovementItem.ObjectId                 AS GoodsId
                            , COALESCE (MILO_GoodsKind.ObjectId, 0) AS GoodsKindId
                       FROM tmpMI_Master
                            INNER JOIN MovementItem ON MovementItem.MovementId = tmpMI_Master.MovementId
                                                   AND MovementItem.ParentId   = tmpMI_Master.MovementItemId
                                                   AND MovementItem.DescId     = zc_MI_Child()
                                                   AND MovementItem.isErased   = FALSE
                            LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                             ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                       )

     , tmpReceiptChild AS (SELECT tmp.ReceiptId
                                , COALESCE (ObjectLink_ReceiptChild_Goods.ChildObjectId, 0)      AS GoodsId
                                , COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0)  AS GoodsKindId
                                , ObjectFloat_Value.ValueData                                    AS AmountReceipt
                                , COALESCE (ObjectBoolean_TaxExit.ValueData, FALSE)              AS isTaxExit
                                , COALESCE (ObjectBoolean_WeightMain.ValueData, FALSE)           AS isWeightMain
                            FROM (SELECT DISTINCT tmpMI_Master.ReceiptId FROM tmpMI_Master
                                  ) AS tmp
                                  INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                        ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = tmp.ReceiptId
                                                       AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                                  LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                       ON ObjectLink_ReceiptChild_Goods.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                      AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                                  LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                                       ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                      AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                                  INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                         ON ObjectFloat_Value.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                        AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                        AND ObjectFloat_Value.ValueData <> 0
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_WeightMain
                                                          ON ObjectBoolean_WeightMain.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                         AND ObjectBoolean_WeightMain.DescId = zc_ObjectBoolean_ReceiptChild_WeightMain()
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_TaxExit
                                                          ON ObjectBoolean_TaxExit.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                         AND ObjectBoolean_TaxExit.DescId = zc_ObjectBoolean_ReceiptChild_TaxExit()
                            )

                
   -- данные по элементам Child
   INSERT INTO _tmpChild (MovementItemId, AmountReceipt, isWeightMain, isTaxExit)
   --
      SELECT tmpMI_Child.MovementItemId_Child AS MovementItemId
           , tmpReceiptChild.AmountReceipt    AS AmountReceipt
           , tmpReceiptChild.isWeightMain     AS isWeightMain
           , tmpReceiptChild.isTaxExit        AS isTaxExit
      FROM tmpMI_Child
           INNER JOIN tmpReceiptChild ON tmpReceiptChild.ReceiptId   = tmpMI_Child.ReceiptId
                                     AND tmpReceiptChild.GoodsId     = tmpMI_Child.GoodsId
                                     AND tmpReceiptChild.GoodsKindId = tmpMI_Child.GoodsKindId
     ;


      -- сохраняем свойства из рецептуры
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountReceipt(), _tmpChild.MovementItemId, COALESCE (_tmpChild.AmountReceipt, 0))
             , lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_TaxExit(), _tmpChild.MovementItemId, COALESCE (_tmpChild.isTaxExit, FALSE))
             , lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_WeightMain(), _tmpChild.MovementItemId, COALESCE (_tmpChild.isWeightMain, FALSE))
             --, lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), MovementItem.Id, inUserId)
             --, lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), MovementItem.Id, CURRENT_TIMESTAMP)
       FROM _tmpChild;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.07.18         *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_ProductionUnion_ReceiptParam (inStartDate:= '01.02.2015', inEndDate:= '01.02.2015', inFromId:= 8447, inToId:= 8447, inSession:= '2')

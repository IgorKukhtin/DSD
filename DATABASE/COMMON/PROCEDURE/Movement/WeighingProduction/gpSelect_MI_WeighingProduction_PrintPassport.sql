-- Function: gpSelect_MI_WeighingProduction_PrintPassport (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MI_WeighingProduction_PrintPassport (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_WeighingProduction_PrintPassport(
    IN inMovementId        Integer   ,   -- ключ Документа
    IN inId                Integer   ,   -- строка
    IN inSession           TVarChar      -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbStoreKeeperName TVarChar;
    DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_wms_Movement_WeighingProduction());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Строка не определена.';
     END IF;

     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate
            -- кладовщик
          , CASE WHEN Object_User.Id = 5 THEN 'Морозенко А.А.' ELSE Object_User.ValueData END
            INTO vbDescId, vbStatusId, vbOperDate, vbStoreKeeperName
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                       ON MovementLinkObject_User.MovementId = Movement.Id
                                      AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
          LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId
     WHERE Movement.Id = inMovementId;

    -- очень важная проверка
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
    END IF;

    OPEN Cursor1 FOR

       -- Результат
   WITH
   tmpBox AS (SELECT tmp.* FROM gpGet_MI_WeighingProduction_Box (inId, inSession) AS tmp)

  , tmpMI AS (SELECT MovementItem.Id              AS MovementItemId
                   , zfFormat_BarCode (zc_BarCodePref_MI(), MovementItem.Id )  AS BarCode
                   , MovementItem.ObjectId        AS GoodsId
                   , Object_Goods.ObjectCode      AS GoodsCode
                   , Object_Goods.ValueData       AS GoodsName
                   , Object_GoodsKind.Id          AS GoodsKindId
                   , Object_GoodsKind.ValueData   AS GoodsKindName
                   , MIFloat_PartionNum.ValueData AS PartionNum
                   , COALESCE (MIDate_PartionGoods.ValueData, vbOperDate) :: TDateTime AS PartionGoodsDate

                   , vbStoreKeeperName  ::TVarChar AS StoreKeeperName

                   , CASE WHEN vbDescId = zc_Movement_WeighingProduction() AND OL_Measure.ChildObjectId = zc_Measure_Sh()
                               THEN MovementItem.Amount * COALESCE (OF_Weight.ValueData, 0)
                          ELSE  MovementItem.Amount
                     END ::TFloat AS Amount

                   , CAST (CASE WHEN vbDescId = zc_Movement_WeighingProduction() AND OL_Measure.ChildObjectId = zc_Measure_Sh()
                                     THEN MovementItem.Amount
                                WHEN vbDescId = zc_Movement_WeighingPartner() AND OL_Measure.ChildObjectId = zc_Measure_Sh() AND  OF_Weight.ValueData > 0
                                     THEN MovementItem.Amount / COALESCE (OF_Weight.ValueData, 0)
                                ELSE  0
                           END AS NUMERIC (16, 0)
                          )::TFloat AS Amount_sh

                   , OL_Measure.ChildObjectId :: Integer AS MeasureId
                   , zc_Measure_Sh()          :: Integer AS zc_Measure_Sh

                   , tmpBox.CountTare1    ::TFloat
                   , tmpBox.CountTare2    ::TFloat
                   , tmpBox.CountTare3    ::TFloat
                   , tmpBox.CountTare4    ::TFloat
                   , tmpBox.CountTare5    ::TFloat
                   , tmpBox.CountTare6    ::TFloat
                   , tmpBox.CountTare7    ::TFloat
                   , tmpBox.CountTare8    ::TFloat
                   , tmpBox.CountTare9    ::TFloat
                   , tmpBox.CountTare10   ::TFloat

                   , tmpBox.BoxName_1 ::TVarChar, tmpBox.BoxName_2 ::TVarChar, tmpBox.BoxName_3 ::TVarChar, tmpBox.BoxName_4 ::TVarChar, tmpBox.BoxName_5 ::TVarChar
                   , tmpBox.BoxName_6 ::TVarChar, tmpBox.BoxName_7 ::TVarChar, tmpBox.BoxName_8 ::TVarChar, tmpBox.BoxName_9 ::TVarChar, tmpBox.BoxName_10 ::TVarChar

                   , Object_PartionCell.Id                   AS PartionCellId
                   , Object_PartionCell.ValueData ::TVarChar AS PartionCellName

              FROM MovementItem

                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                   LEFT JOIN MovementItemFloat AS MIFloat_PartionNum
                                               ON MIFloat_PartionNum.MovementItemId = MovementItem.Id
                                              AND MIFloat_PartionNum.DescId = zc_MIFloat_PartionNum()

                   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                              ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                             AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                   LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell
                                                    ON MILinkObject_PartionCell.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_PartionCell.DescId = zc_MILinkObject_PartionCell()
                   LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = MILinkObject_PartionCell.ObjectId

                   LEFT JOIN tmpBox ON 1 = 1

                   LEFT JOIN ObjectLink AS OL_Measure
                                        ON OL_Measure.ObjectId = MovementItem.ObjectId
                                       AND OL_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                   LEFT JOIN ObjectFloat AS OF_Weight
                                         ON OF_Weight.ObjectId = MovementItem.ObjectId
                                        AND OF_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.Id         = inId
             )

       --результат
       SELECT *
       FROM tmpMI
        ;

    RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
03.02.20          *
*/

-- тест
-- SELECT * FROM gpSelect_MI_WeighingProduction_PrintPassport(inMovementId := 15745229 , inId := 162901040 ,  inSession := '5'); --FETCH ALL "<unnamed portal 12>";

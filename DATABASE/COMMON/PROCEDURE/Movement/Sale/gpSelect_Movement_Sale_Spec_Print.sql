-- Function: gpSelect_Movement_Sale_Spec_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_Pack_Print22 (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_Spec_Print (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_Spec_Print (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale_Spec_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMovementId_by     Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbGoodsPropertyId Integer;

    DECLARE Cursor1 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale_Spec_Print());
     vbUserId:= lpGetUserBySession (inSession);


     -- определяется параметр
     vbGoodsPropertyId:= (SELECT zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId), MovementLinkObject_To.ObjectId)
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                          WHERE Movement.Id = inMovementId
                         );


     -- Данные: заголовок + строчная часть
     OPEN Cursor1 FOR
     WITH -- список всех Документов Взвешивания или одного - inMovementId_by
          tmpMovement AS (SELECT Movement.Id, Movement.ParentId
                          FROM Movement
                          WHERE Movement.ParentId = inMovementId
                            AND Movement.DescId = zc_Movement_WeighingPartner()
                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                            AND (Movement.Id = inMovementId_by OR COALESCE (inMovementId_by, 0) = 0)
                         )
       -- список Артикулы покупателя для товаров + GoodsKindId
     , tmpObject_GoodsPropertyValue AS (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
                                             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                             , Object_GoodsPropertyValue.ValueData  AS Name
                                             , ObjectString_BarCode.ValueData       AS BarCode
                                             , ObjectString_Article.ValueData       AS Article
                                        FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
                                             ) AS tmpGoodsProperty
                                             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                             LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId

                                             LEFT JOIN ObjectString AS ObjectString_BarCode
                                                                    ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                   AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
                                             LEFT JOIN ObjectString AS ObjectString_Article
                                                                    ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                   AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()
                                             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                       )
       -- список Артикулы для товаров (нужны если не найдем по GoodsKindId)
     , tmpObject_GoodsPropertyValueGroup AS (SELECT tmpObject_GoodsPropertyValue.GoodsId
                                                  , tmpObject_GoodsPropertyValue.Name
                                                  , tmpObject_GoodsPropertyValue.Article
                                                  , tmpObject_GoodsPropertyValue.BarCode
                                             FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE Article <> '' GROUP BY GoodsId
                                                  ) AS tmpGoodsProperty_find
                                                  LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
                                            )
       -- строчная часть документов Взвешивания или одного - inMovementId_by
     , tmpMI AS (SELECT MovementItem.*
                 FROM tmpMovement
                      INNER JOIN MovementItem ON MovementItem.MovementId =  tmpMovement.Id
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = FALSE
                                             AND MovementItem.Amount    <> 0
                )       

     , tmpMIFloat AS (SELECT MovementItemFloat.*
                      FROM MovementItemFloat
                      WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                        AND MovementItemFloat.DescId IN (zc_MIFloat_AmountPartner()
                                                       , zc_MIFloat_BoxCount()
                                                       , zc_MIFloat_BoxNumber()
                                                       , zc_MIFloat_LevelNumber()
                                                         )
                     )
     , tmpMILinkObject_GoodsKind AS (SELECT MovementItemLinkObject.*
                                     FROM MovementItemLinkObject
                                     WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                       AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                                    )
     , tmpMILinkObject_Box AS (SELECT MovementItemLinkObject.*
                                     FROM MovementItemLinkObject
                                     WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                       AND MovementItemLinkObject.DescId = zc_MILinkObject_Box()
                                    )

     , tmpMovementItem AS (SELECT MovementItem.MovementId                             AS MovementId
                                , MovementItem.ObjectId                               AS GoodsId
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                                , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountPartner
                                , SUM (COALESCE (MIFloat_BoxCount.ValueData, 0))      AS BoxCount
                                , COALESCE (MIFloat_BoxNumber.ValueData, 0)           AS BoxNumber
                                , MILinkObject_Box.ObjectId                           AS BoxId
                           FROM tmpMI AS MovementItem
                                LEFT JOIN tmpMIFloat AS MIFloat_AmountPartner
                                                            ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                LEFT JOIN tmpMIFloat AS MIFloat_BoxCount
                                                            ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                                           AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()
                                LEFT JOIN tmpMIFloat AS MIFloat_BoxNumber
                                                            ON MIFloat_BoxNumber.MovementItemId = MovementItem.Id
                                                           AND MIFloat_BoxNumber.DescId = zc_MIFloat_BoxNumber()
                                LEFT JOIN tmpMIFloat AS MIFloat_LevelNumber
                                                            ON MIFloat_LevelNumber.MovementItemId = MovementItem.Id
                                                           AND MIFloat_LevelNumber.DescId = zc_MIFloat_LevelNumber()
                                LEFT JOIN tmpMILinkObject_GoodsKind AS MILinkObject_GoodsKind
                                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                LEFT JOIN tmpMILinkObject_Box AS MILinkObject_Box
                                                                 ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Box.DescId = zc_MILinkObject_Box()
                           GROUP BY MovementItem.MovementId
                                  , MovementItem.ObjectId
                                  , MILinkObject_GoodsKind.ObjectId
                                  , MILinkObject_Box.ObjectId
                                  , MIFloat_BoxNumber.ValueData
                          )

     , tmpMovementFloat AS (SELECT MovementFloat.*
                            FROM MovementFloat
                            WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                              AND MovementFloat.DescId IN (zc_MovementFloat_WeighingNumber()
                                                         , zc_MovementFloat_TotalCountKg())
                           )

     , tmpMovementDate_OperDatePartner AS (SELECT MovementDate.*
                                           FROM MovementDate
                                           WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.ParentId FROM tmpMovement)
                                             AND MovementDate.DescId = zc_MovementDate_OperDatePartner()
                                           )
     , tmpMovementString_Parent AS (SELECT MovementString.*
                                    FROM MovementString
                                    WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement.ParentId FROM tmpMovement)
                                      AND MovementString.DescId IN (zc_MovementString_InvNumberPartner()
                                                                  , zc_MovementString_InvNumberOrder())
                                    )

     , tmpMLO_Contract AS (SELECT MovementLinkObject.*
                           FROM MovementLinkObject
                           WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.ParentId FROM tmpMovement)
                             AND MovementLinkObject.DescId = zc_MovementLinkObject_Contract()
                           )

      -- Результат
      SELECT tmpMovementItem.MovementId	                                            AS MovementId
           , CAST (ROW_NUMBER() OVER (PARTITION BY MovementFloat_WeighingNumber.ValueData ORDER BY tmpMovementItem.BoxNumber) AS Integer) AS NumOrder
           , Movement_Sale.OperDate				                    AS OperDate
           , COALESCE (MovementDate_OperDatePartner.ValueData, Movement_Sale.OperDate) AS OperDatePartner
           , MovementFloat_WeighingNumber.ValueData                                 AS WeighingNumber
           , Movement_Sale.InvNumber		                                    AS InvNumber
           , MovementString_InvNumberPartner.ValueData                              AS InvNumberPartner
           , MovementString_InvNumberOrder.ValueData                                AS InvNumberOrder
           , MovementFloat_TotalCountKg.ValueData                                   AS TotalCountKg

           , OH_JuridicalDetails_From.FullName                                      AS JuridicalName_From
           , OH_JuridicalDetails_From.JuridicalAddress                              AS JuridicalAddress_From

           , OH_JuridicalDetails_To.FullName                                        AS JuridicalName_To
           , OH_JuridicalDetails_To.JuridicalAddress                                AS JuridicalAddress_To
           , ObjectString_ToAddress.ValueData                                       AS PartnerAddress_To

           , Object_From.ValueData             		                            AS FromName
           , Object_To.ValueData                                                    AS ToName

           , Object_Goods.ObjectCode                                                AS GoodsCode
           , (CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name ELSE Object_Goods.ValueData END || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END) :: TVarChar AS GoodsName
           , CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name ELSE Object_Goods.ValueData END :: TVarChar AS GoodsName_two
           , COALESCE (tmpObject_GoodsPropertyValueGroup.Name, tmpObject_GoodsPropertyValue.Name) AS GoodsName_Juridical
           , Object_GoodsKind.ValueData                                             AS GoodsKindName
           , Object_Measure.ValueData                                               AS MeasureName
           , COALESCE (tmpObject_GoodsPropertyValue.Article, COALESCE (tmpObject_GoodsPropertyValueGroup.Article, '')) AS Article_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BarCode, COALESCE (tmpObject_GoodsPropertyValueGroup.BarCode, '')) AS BarCode_Juridical
           , tmpMovementItem.BoxNumber                                              AS BoxNumber
           , tmpMovementItem.BoxCount                                               AS BoxCount
           , tmpMovementItem.AmountPartner                                          AS AmountPartner
           , (tmpMovementItem.AmountPartner * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 0 END) :: TFloat AS AmountPartnerWeight

       FROM tmpMovement
            INNER JOIN tmpMovementItem ON tmpMovementItem.MovementId = tmpMovement.Id

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = tmpMovement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = tmpMovement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId


            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMovementItem.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMovementItem.GoodsKindId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectFloat AS OF_Box_Weight
                                  ON OF_Box_Weight.ObjectId = tmpMovementItem.BoxId
                                 AND OF_Box_Weight.DescId = zc_ObjectFloat_Box_Weight()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN tmpMovementFloat AS MovementFloat_WeighingNumber
                                       ON MovementFloat_WeighingNumber.MovementId = tmpMovement.Id
                                      AND MovementFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountKg
                                       ON MovementFloat_TotalCountKg.MovementId = tmpMovement.Id
                                      AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = Object_Goods.Id
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = Object_GoodsKind.Id
            LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = Object_Goods.Id
                                                       AND tmpObject_GoodsPropertyValue.GoodsId IS NULL

-- MOVEMENT
            LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = tmpMovement.ParentId
            LEFT JOIN tmpMovementDate_OperDatePartner AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement_Sale.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN tmpMovementString_Parent AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement_Sale.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN tmpMovementString_Parent AS MovementString_InvNumberOrder
                                     ON MovementString_InvNumberOrder.MovementId = Movement_Sale.Id
                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

            LEFT JOIN tmpMLO_Contract AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = MovementLinkObject_Contract.ObjectId

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                ON OH_JuridicalDetails_From.JuridicalId = COALESCE (ObjectLink_Unit_Juridical.ChildObjectId, View_Contract.JuridicalBasisId)
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement_Sale.OperDate) >= OH_JuridicalDetails_From.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement_Sale.OperDate) <  OH_JuridicalDetails_From.EndDate
            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                ON OH_JuridicalDetails_To.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement_Sale.OperDate) >= OH_JuridicalDetails_To.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement_Sale.OperDate) <  OH_JuridicalDetails_To.EndDate
            LEFT JOIN ObjectString AS ObjectString_ToAddress
                                   ON ObjectString_ToAddress.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectString_ToAddress.DescId = zc_ObjectString_Partner_Address()
      ;
     RETURN NEXT Cursor1;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Sale_Spec_Print (Integer, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 04.04.19         *
 25.05.15                                        * ALL
 24.11.14                                                       *
 03.11.14                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Sale_Spec_Print (inMovementId := 12893608, inMovementId_by:=0, inSession:= zfCalc_UserAdmin());
-- FETCH ALL "<unnamed portal 12>";
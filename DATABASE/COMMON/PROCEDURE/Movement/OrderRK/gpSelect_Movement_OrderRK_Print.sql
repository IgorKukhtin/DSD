-- Function: gpSelect_Movement_OrderRK_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderRK_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderRK_Print(
    IN inMovementId    Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbOperDate TDateTime;

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderRK());
     vbUserId:= lpGetUserBySession (inSession);


     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate
          --
          , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_From.ObjectId), COALESCE (MovementLinkObject_Partner.ObjectId, MovementLinkObject_From.ObjectId)) AS GoodsPropertyId
          , zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0)      AS GoodsPropertyId_basis
  INTO vbDescId, vbStatusId, vbOperDate
     , vbGoodsPropertyId, vbGoodsPropertyId_basis
     FROM Movement
          LEFT JOIN Movement AS Movement_OrderExternal ON Movement_OrderExternal.Id = Movement.ParentId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.ParentId
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.ParentId
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                       ON MovementLinkObject_Partner.MovementId = Movement.ParentId
                                      AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                      AND Object_From.DescId = zc_Object_Unit()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, MovementLinkObject_From.ObjectId)
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()    
     WHERE Movement.Id = inMovementId;
     
     
/*
     -- очень важная проверка
     IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete() AND vbUserId <> 5 -- !!!кроме Админа!!!
     THEN
         IF vbStatusId = zc_Enum_Status_Erased()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         IF vbStatusId = zc_Enum_Status_UnComplete()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         -- это уже странная ошибка
         RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
     END IF;

*/



     --
     OPEN Cursor1 FOR
     SELECT
             Movement.Id                         AS Id
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
           , Movement.InvNumber                  AS InvNumber
           , Movement.OperDate ::TDateTime       AS OperDate
           , COALESCE (MovementBoolean_Print.ValueData, False) ::Boolean AS isPrint
           , MovementDate_Print.ValueData                    ::TDateTime AS OperDate_Print
           , MovementDate_CarInfo.ValueData                  ::TDateTime AS OperDate_CarInfo
           , Object_Route.ValueData        AS RouteName
           , Object_Retail.ValueData       AS RetailName
           , Object_From.Id                AS FromId
           , Object_From.ValueData         AS FromName 
           , Object_To.ObjectCode          AS ToCode
           , Object_To.ValueData           AS ToName
           , MovementString_Comment.ValueData    AS Comment
           , Object_Insert.ValueData             AS InsertName
           , MovementDate_Insert.ValueData       AS InsertDate

           , Movement_OrderExternal.Id           AS MovementId_OrderExternal
           , Movement_OrderExternal.InvNumber    AS InvNumber_OrderExternal
           , Movement_OrderExternal.OperDate     AS OperDate_OrderExternal
           , MovementDate_OperDatePartner_order.ValueData AS OperDatePartner_OrderExternal
           , COALESCE (MovementDate_OperDatePartner_Effie.ValueData, MovementDate_OperDatePartner_order.ValueData + (COALESCE (ObjectFloat_DocumentDayCount_order.ValueData, 0) :: TVarChar || ' DAY') :: INTERVAL) :: TDateTime AS OperDatePartner_sale_OE
           , MovementString_Comment_OrderExternal.ValueData    AS Comment_OrderExternal
           , MovementFloat_TotalCountKg.ValueData   ::TFloat   AS TotalCountKg
           , MovementFloat_TotalCountSh.ValueData   ::TFloat   AS TotalCountSh
           , MovementFloat_TotalCount.ValueData     ::TFloat   AS TotalCount          
       FROM Movement
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_Print
                                      ON MovementBoolean_Print.MovementId = Movement.Id
                                     AND MovementBoolean_Print.DescId = zc_MovementBoolean_Print()

            LEFT JOIN MovementDate AS MovementDate_Print
                                   ON MovementDate_Print.MovementId = Movement.Id
                                  AND MovementDate_Print.DescId = zc_MovementDate_Print()

            LEFT JOIN MovementDate AS MovementDate_CarInfo
                                   ON MovementDate_CarInfo.MovementId = Movement.Id
                                  AND MovementDate_CarInfo.DescId = zc_MovementDate_CarInfo()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
 
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = Movement.Id
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                         ON MovementLinkObject_Retail.MovementId = Movement.Id
                                        AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MovementLinkObject_Retail.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN Movement AS Movement_OrderExternal ON Movement_OrderExternal.Id = Movement.ParentId

            ---
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner_order
                                   ON MovementDate_OperDatePartner_order.MovementId = Movement_OrderExternal.Id
                                  AND MovementDate_OperDatePartner_order.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner_Effie
                                   ON MovementDate_OperDatePartner_Effie.MovementId = Movement_OrderExternal.Id
                                  AND MovementDate_OperDatePartner_Effie.DescId = zc_MovementDate_OperDatePartner_Effie()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From_order
                                         ON MovementLinkObject_From_order.MovementId = Movement_OrderExternal.Id
                                        AND MovementLinkObject_From_order.DescId = zc_MovementLinkObject_From()

            LEFT JOIN ObjectFloat AS ObjectFloat_DocumentDayCount_order
                                  ON ObjectFloat_DocumentDayCount_order.ObjectId = MovementLinkObject_From_order.ObjectId
                                 AND ObjectFloat_DocumentDayCount_order.DescId = zc_ObjectFloat_Partner_DocumentDayCount()

            LEFT JOIN MovementString AS MovementString_Comment_OrderExternal
                                     ON MovementString_Comment_OrderExternal.MovementId = Movement_OrderExternal.Id
                                    AND MovementString_Comment_OrderExternal.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId = Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId = Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()                                 

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_OrderRK();

    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
       
    WITH
    tmpObject_GoodsPropertyValue AS
       (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId      AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0)  AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
             , ObjectFloat_Amount.ValueData         AS Amount
             , ObjectFloat_BoxCount.ValueData       AS BoxCount
             , ObjectString_BarCode.ValueData       AS BarCode
             , ObjectString_Article.ValueData       AS Article
             , ObjectString_BarCodeGLN.ValueData    AS BarCodeGLN
             , ObjectString_ArticleGLN.ValueData    AS ArticleGLN
             , ObjectString_CodeSticker.ValueData   AS CodeSticker
             , ObjectString_Goods_ShortName.ValueData AS GoodsBoxName_short
        FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                   ON ObjectFloat_Amount.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectFloat_Amount.DescId = zc_ObjectFloat_GoodsPropertyValue_Amount()

             LEFT JOIN ObjectFloat AS ObjectFloat_BoxCount
                                   ON ObjectFloat_BoxCount.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectFloat_BoxCount.DescId = zc_ObjectFloat_GoodsPropertyValue_BoxCount()

             LEFT JOIN ObjectString AS ObjectString_BarCode
                                    ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()

             LEFT JOIN ObjectString AS ObjectString_BarCodeGLN
                                    ON ObjectString_BarCodeGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCodeGLN.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeGLN()
             LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                                    ON ObjectString_ArticleGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()
             LEFT JOIN ObjectString AS ObjectString_CodeSticker
                                    ON ObjectString_CodeSticker.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_CodeSticker.DescId = zc_ObjectString_GoodsPropertyValue_CodeSticker()

             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()

             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsBox
                                  ON ObjectLink_GoodsPropertyValue_GoodsBox.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsBox.DescId   = zc_ObjectLink_GoodsPropertyValue_GoodsBox()
             LEFT JOIN ObjectString AS ObjectString_Goods_ShortName
                                    ON ObjectString_Goods_ShortName.ObjectId = ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId
                                   AND ObjectString_Goods_ShortName.DescId   = zc_ObjectString_Goods_ShortName()

        WHERE Object_GoodsPropertyValue.ValueData    <> ''
           OR ObjectString_BarCode.ValueData         <> ''
           OR ObjectString_Article.ValueData         <> ''
           OR ObjectString_BarCodeGLN.ValueData      <> ''
           OR ObjectString_ArticleGLN.ValueData      <> ''
           OR ObjectString_CodeSticker.ValueData     <> ''
           OR ObjectString_Goods_ShortName.ValueData <> ''
           OR ObjectFloat_BoxCount.ValueData         <> 0
       )
     , tmpObject_GoodsPropertyValueGroup_GoodsBoxName_short AS
       (SELECT tmpObject_GoodsPropertyValue.GoodsId
             , tmpObject_GoodsPropertyValue.GoodsBoxName_short
        FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId
              FROM tmpObject_GoodsPropertyValue
              WHERE GoodsBoxName_short <> ''
                AND tmpObject_GoodsPropertyValue.GoodsKindId IN (0, zc_GoodsKind_Basis())
              GROUP BY GoodsId
             ) AS tmpGoodsProperty_find
             LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
       )
     , tmpObject_GoodsPropertyValueGroup_BoxCount AS
       (SELECT tmpObject_GoodsPropertyValue.GoodsId
             , tmpObject_GoodsPropertyValue.BoxCount
        FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId
              FROM tmpObject_GoodsPropertyValue
              WHERE BoxCount <> 0
                AND tmpObject_GoodsPropertyValue.GoodsKindId IN (0, zc_GoodsKind_Basis())
                AND 1=0
              GROUP BY GoodsId
             ) AS tmpGoodsProperty_find
             LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
       )
     , tmpObject_GoodsPropertyValue_basis AS
       (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
        FROM (SELECT vbGoodsPropertyId_basis AS GoodsPropertyId
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             INNER JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                           AND Object_GoodsPropertyValue.ValueData <> ''
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
       )
     ---
     , tmpMI AS (SELECT MovementItem.Id                               AS Id
                      , MovementItem.Amount                           AS Amount
                      , MovementItem.ObjectId                         AS GoodsId
                 FROM MovementItem
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.isErased   = FALSE
                 )

     , tmpGoods_Param AS (SELECT tmp.GoodsId
                               , Object_Measure.ValueData       AS MeasureName
                               , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                               , Object_GoodsGroup.ValueData                 AS GoodsGroupName
                         FROM (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmp
                              LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                                     ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmp.GoodsId
                                                    AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                  ON ObjectLink_Goods_Measure.ObjectId = tmp.GoodsId
                                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = tmp.GoodsId
                                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
                        )

     , tmpMILO_GoodsKind AS (SELECT MovementItemLinkObject.*
                             FROM MovementItemLinkObject
                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                               AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind())
                            )
     , tmpMILO_Goods_in AS (SELECT MovementItemLinkObject.*
                             FROM MovementItemLinkObject
                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                               AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Goods_in())
                            )
     , tmpMILO_GoodsKind_in AS (SELECT MovementItemLinkObject.*
                                FROM MovementItemLinkObject
                                WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                  AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind_in())
                               )
        SELECT
             MovementItem.Id                  :: Integer AS Id
           , ROW_NUMBER() OVER (Order BY MovementItem.Id)  ::Integer AS LineNum
           , Object_Goods.Id                             AS GoodsId
           , Object_Goods.ObjectCode                     AS GoodsCode
           , Object_Goods.ValueData                      AS GoodsName
           , tmpGoods_Param.GoodsGroupNameFull ::TVarChar AS GoodsGroupNameFull
           , tmpGoods_Param.GoodsGroupName     ::TVarChar AS GoodsGroupName
           , tmpGoods_Param.MeasureName        ::TVarChar AS MeasureName
           , COALESCE (Object_GoodsKind.Id, 0)           AS GoodsKindId
           , Object_GoodsKind.ValueData                  AS GoodsKindName

           , Object_Goods_in.Id                   AS GoodsId_in
           , Object_Goods_in.ObjectCode           AS GoodsCode_in
           , Object_Goods_in.ValueData            AS GoodsName_in
           , COALESCE (Object_GoodsKind_in.Id, 0) AS GoodsKindId_in
           , Object_GoodsKind_in.ValueData        AS GoodsKindName_in

           , MovementItem.Amount        :: TFloat AS Amount

           --
           , CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END AS GoodsName_two
           , COALESCE (tmpObject_GoodsPropertyValue.CodeSticker, '') :: TVarChar  AS CodeSticker
           , COALESCE (tmpObject_GoodsPropertyValue.GoodsBoxName_short, tmpObject_GoodsPropertyValueGroup_GoodsBoxName_short.GoodsBoxName_short) AS GoodsBoxName_short

           , CAST (CASE WHEN COALESCE (tmpObject_GoodsPropertyValueGroup_BoxCount.BoxCount, tmpObject_GoodsPropertyValue.BoxCount, 0) > 0
                             THEN CAST ((MovementItem.Amount) / COALESCE (tmpObject_GoodsPropertyValueGroup_BoxCount.BoxCount, tmpObject_GoodsPropertyValue.BoxCount, 0) AS NUMERIC (16, 4))
                        ELSE 0
                   END AS NUMERIC(16,1)) :: TFloat AS AmountBox

           , COALESCE (tmpObject_GoodsPropertyValueGroup_BoxCount.BoxCount, tmpObject_GoodsPropertyValue.BoxCount, 0) :: TFloat    AS BoxCount

       FROM tmpMI AS MovementItem
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
           LEFT JOIN tmpGoods_Param ON tmpGoods_Param.GoodsId = MovementItem.GoodsId

           LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
           LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

           LEFT JOIN tmpMILO_Goods_in AS MILinkObject_Goods_in
                                      ON MILinkObject_Goods_in.MovementItemId = MovementItem.Id
                                     AND MILinkObject_Goods_in.DescId = zc_MILinkObject_Goods_in()
           LEFT JOIN Object AS Object_Goods_in ON Object_Goods_in.Id = MILinkObject_Goods_in.ObjectId

           LEFT JOIN tmpMILO_GoodsKind_in AS MILinkObject_GoodsKind_in
                                          ON MILinkObject_GoodsKind_in.MovementItemId = MovementItem.Id
                                         AND MILinkObject_GoodsKind_in.DescId = zc_MILinkObject_GoodsKind_in()
           LEFT JOIN Object AS Object_GoodsKind_in ON Object_GoodsKind_in.Id = MILinkObject_GoodsKind_in.ObjectId

           LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = MovementItem.GoodsId
                                                 AND tmpObject_GoodsPropertyValue.GoodsKindId = Object_GoodsKind.Id

           LEFT JOIN tmpObject_GoodsPropertyValueGroup_GoodsBoxName_short ON tmpObject_GoodsPropertyValueGroup_GoodsBoxName_short.GoodsId = MovementItem.GoodsId
                                                                         AND COALESCE (tmpObject_GoodsPropertyValue.GoodsBoxName_short, '') = ''
           LEFT JOIN tmpObject_GoodsPropertyValueGroup_BoxCount ON tmpObject_GoodsPropertyValueGroup_BoxCount.GoodsId = MovementItem.GoodsId
                                                               AND COALESCE (tmpObject_GoodsPropertyValue.BoxCount, 0) = 0

           LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = MovementItem.GoodsId
                                                       AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = Object_GoodsKind.Id
           ;   

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.08.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderRK_Print (inMovementId := 34939264 , inSession:= zfCalc_UserAdmin())   --FETCH ALL "<unnamed portal 9>";

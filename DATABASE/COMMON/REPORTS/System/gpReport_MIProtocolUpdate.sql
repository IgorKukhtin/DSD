-- Function: gpReport_MIProtocolUpdate (TDateTime, TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpReport_MIProtocolUpdate (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MIProtocolUpdate(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inUnitId             Integer , --
    IN inUserId             Integer , --
    IN inGoodsGroupId       Integer   ,
    IN inGoodsId            Integer   ,
    IN inIsMovement         Boolean , --
    IN inSession            TVarChar  -- сессия пользователя
)
RETURNS TABLE (UserId Integer, UserCode Integer, UserName TVarChar
             , MemberName     TVarChar
             , PositionName   TVarChar
             , UnitId Integer, UnitName TVarChar
             , BranchId Integer, BranchName TVarChar

             , MovementId          Integer
             , MovementItemId      Integer
             , OperDate_Protocol   TDateTime
             , OperDate_Movement   TDateTime
             , Invnumber_Movement  Integer
             , DescId_Movement     Integer
             , DescName_Movement   TVarChar
             , StatusCode          Integer
             , StatusName          TVarChar
             , FromName            TVarChar
             , ToName              TVarChar

             , Text_inf      TVarChar
             , GoodsCode     Integer
             , GoodsName     TVarChar
             , GoodsKindName TVarChar
             , Amount        Tfloat
             , AmountPartner Tfloat
             , Price         Tfloat
             , IsInsert      Boolean
             , isErased      Boolean
             , isErased_Object  Boolean 

             , GoodsCode_change     Integer
             , GoodsName_change     TVarChar
             , GoodsKindName_change TVarChar
             , Amount_change        Tfloat
             , AmountPartner_change TFloat
             , Price_change         TFloat
             , isErased_change      Boolean

              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- Результат
   RETURN QUERY
    WITH
    tmpPersonal AS (SELECT View_Personal.MemberId
                          , MAX (View_Personal.PersonalId) AS PersonalId
                          , MAX (View_Personal.UnitId) AS UnitId
                          , MAX (View_Personal.PositionId) AS PositionId
                    FROM Object_Personal_View AS View_Personal
                    GROUP BY View_Personal.MemberId
                    )

  , tmpUser AS (SELECT Object_User.Id AS UserId
                     , Object_User.ObjectCode AS UserCode
                     , Object_User.ValueData  AS UserName
                     , tmpPersonal.MemberId
                     , ObjectLink_Unit_Branch.ChildObjectId AS BranchId
                     , tmpPersonal.UnitId
                     , tmpPersonal.PositionId
                FROM Object AS Object_User
                      LEFT JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = Object_User.Id
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                      LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
                      LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                             ON ObjectLink_Unit_Branch.ObjectId = tmpPersonal.UnitId
                            AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()

                WHERE Object_User.DescId = zc_Object_User()
                )

  , tmpUnit AS (SELECT lfSelect_Object_Unit_byGroup.UnitId AS UnitId
                FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect_Object_Unit_byGroup
                WHERE inUnitId <> 0
               UNION
                SELECT Object.Id AS UnitId
                FROM Object
                WHERE Object.DescId = zc_Object_Unit()
                  AND COALESCE (inUnitId, 0) = 0
               )

  , tmpGoods AS (SELECT lfSelect.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                 WHERE inGoodsGroupId <> 0 AND COALESCE (inGoodsId, 0) = 0
               UNION
                 SELECT inGoodsId WHERE inGoodsId > 0
               UNION
                 SELECT Object.Id FROM Object
                 WHERE Object.DescId = zc_Object_Goods() --AND (inStartDate + INTERVAL '3 DAY') >= inEndDate
                   AND COALESCE (inGoodsGroupId, 0) = 0 AND COALESCE (inGoodsId, 0) = 0
               UNION
                 SELECT Object.Id FROM Object
                 WHERE Object.DescId = zc_Object_Goods() --AND inIsErased = TRUE
                   AND COALESCE (inGoodsGroupId, 0) = 0 AND COALESCE (inGoodsId, 0) = 0
                 )

    -- Данные из протокола строк документа
  , tmpMI_Protocol AS (-- MovementItemProtocol
                       SELECT MovementItemProtocol.UserId
                            --, DATE_TRUNC ('DAY', MovementItemProtocol.OperDate) AS OperDate
                            , MovementItemProtocol.OperDate        AS OperDate_Protocol
                            , MovementItemProtocol.MovementItemId  AS MovementItemId
                            , MovementItem.DescId                  AS DescId_MovementItem
                            , Movement.Id                          AS MovementId
                            , Movement.StatusId                    AS StatusId_Movement
                            , Movement.OperDate                    AS OperDate_Movement
                            , Movement.Invnumber                   AS Invnumber_Movement
                            , Movement.DescId                      AS DescId_Movement
                            , MovementDesc.ItemName                AS DescName_Movement
                            , MovementLinkObject_From.ObjectId     AS FromId_Movement
                            , MovementLinkObject_To.ObjectId       AS ToId_Movement
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ключ объекта"]            /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','') ::integer   AS GoodsId
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Виды товаров"]            /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS GoodsKindName
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Значение"]                /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS Amount
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Количество у контрагента"]/@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS AmountPartner
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Цена"]                    /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS Price
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Удален"]                  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS isErased
                            , MovementItemProtocol.IsInsert        AS IsInsert
                       FROM MovementItemProtocol
                            LEFT JOIN MovementItem ON MovementItem.Id = MovementItemProtocol.MovementItemId
                            LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                            INNER JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                                                      AND MovementDesc.Id IN (zc_Movement_ReturnOut()
                                                                            , zc_Movement_Send()
                                                                            , zc_Movement_SendAsset()
                                                                            , zc_Movement_SendOnPrice()
                                                                            , zc_Movement_Sale()
                                                                            , zc_Movement_ReturnIn()
                                                                            , zc_Movement_Loss()
                                                                            , zc_Movement_ProductionSeparate()
                                                                            , zc_Movement_ProductionUnion()
                                                                            , zc_Movement_Inventory()
                                                                            , zc_Movement_Income()
                                                                            , zc_Movement_WeighingPartner()
                                                                            , zc_Movement_WeighingProduction())
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                            LEFT JOIN tmpUnit AS tmpUnit_from ON tmpUnit_from.UnitId = MovementLinkObject_From.ObjectId
                            LEFT JOIN tmpUnit AS tmpUnit_to   ON tmpUnit_to.UnitId   = MovementLinkObject_To.ObjectId

                       WHERE  (MovementItemProtocol.UserId = inUserId OR inUserId = 0)
                          AND ( (inIsMovement = FALSE AND MovementItemProtocol.OperDate >= inStartDate AND MovementItemProtocol.OperDate < inEndDate + INTERVAL '1 DAY')
                               OR
                                (inIsMovement = TRUE AND Movement.OperDate >= inStartDate AND Movement.OperDate < inEndDate + INTERVAL '1 DAY')
                              )
                          AND (tmpUnit_from.UnitId > 0  OR tmpUnit_to.UnitId > 0)
                          AND MovementItemProtocol.IsInsert = FALSE
  
                      -- пока без архива 
                      UNION ALL
                       -- MovementItemProtocol_arc
                       SELECT MovementItemProtocol.UserId
                            , MovementItemProtocol.OperDate        AS OperDate_Protocol
                            , MovementItemProtocol.MovementItemId  AS MovementItemId
                            , MovementItem.DescId                  AS DescId_MovementItem
                            , Movement.Id                          AS MovementId
                            , Movement.StatusId                    AS StatusId_Movement
                            , Movement.OperDate                    AS OperDate_Movement
                            , Movement.Invnumber                   AS Invnumber_Movement
                            , Movement.DescId                      AS DescId_Movement
                            , MovementDesc.ItemName                AS DescName_Movement
                            , MovementLinkObject_From.ObjectId     AS FromId_Movement
                            , MovementLinkObject_To.ObjectId       AS ToId_Movement
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ключ объекта"]            /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','') ::integer   AS GoodsId
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Виды товаров"]            /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS GoodsKindName
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Значение"]                /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS Amount
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Количество у контрагента"]/@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS AmountPartner
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Цена"]                    /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS Price
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Удален"]                  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS isErased
                            , MovementItemProtocol.IsInsert        AS IsInsert
                       FROM MovementItemProtocol_arc AS MovementItemProtocol
                            LEFT JOIN MovementItem ON MovementItem.Id = MovementItemProtocol.MovementItemId
                            LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                            INNER JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                                                      AND MovementDesc.Id IN (zc_Movement_ReturnOut()
                                                                            , zc_Movement_Send()
                                                                            , zc_Movement_SendAsset()
                                                                            , zc_Movement_SendOnPrice()
                                                                            , zc_Movement_Sale()
                                                                            , zc_Movement_ReturnIn()
                                                                            , zc_Movement_Loss()
                                                                            , zc_Movement_ProductionSeparate()
                                                                            , zc_Movement_ProductionUnion()
                                                                            , zc_Movement_Inventory()
                                                                            , zc_Movement_Income()
                                                                            , zc_Movement_WeighingPartner()
                                                                            , zc_Movement_WeighingProduction())
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                            LEFT JOIN tmpUnit AS tmpUnit_from ON tmpUnit_from.UnitId = MovementLinkObject_From.ObjectId
                            LEFT JOIN tmpUnit AS tmpUnit_to   ON tmpUnit_to.UnitId   = MovementLinkObject_To.ObjectId

                       WHERE  (MovementItemProtocol.UserId = inUserId OR inUserId = 0)
                          AND ( (inIsMovement = FALSE AND MovementItemProtocol.OperDate >= inStartDate AND MovementItemProtocol.OperDate < inEndDate + INTERVAL '1 DAY')
                               OR
                                (inIsMovement = TRUE AND Movement.OperDate >= inStartDate AND Movement.OperDate < inEndDate + INTERVAL '1 DAY')
                              )
                          AND (tmpUnit_from.UnitId > 0  OR tmpUnit_to.UnitId > 0)

                      -- пока без архива 
                      UNION ALL
                       -- MovementItemProtocol_arc_arc
                       SELECT MovementItemProtocol.UserId
                            , MovementItemProtocol.OperDate        AS OperDate_Protocol
                            , MovementItemProtocol.MovementItemId  AS MovementItemId
                            , MovementItem.DescId                  AS DescId_MovementItem
                            , Movement.Id                          AS MovementId
                            , Movement.StatusId                    AS StatusId_Movement
                            , Movement.OperDate                    AS OperDate_Movement
                            , Movement.Invnumber                   AS Invnumber_Movement
                            , Movement.DescId                      AS DescId_Movement
                            , MovementDesc.ItemName                AS DescName_Movement
                            , MovementLinkObject_From.ObjectId     AS FromId_Movement
                            , MovementLinkObject_To.ObjectId       AS ToId_Movement
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ключ объекта"]            /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','') ::integer   AS GoodsId
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Виды товаров"]            /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS GoodsKindName
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Значение"]                /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS Amount
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Количество у контрагента"]/@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS AmountPartner
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Цена"]                    /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS Price
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Удален"]                  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS isErased
                            , MovementItemProtocol.IsInsert        AS IsInsert
                       FROM MovementItemProtocol_arc_arc AS MovementItemProtocol
                            LEFT JOIN MovementItem ON MovementItem.Id = MovementItemProtocol.MovementItemId
                            LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                            INNER JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                                                      AND MovementDesc.Id IN (zc_Movement_ReturnOut()
                                                                            , zc_Movement_Send()
                                                                            , zc_Movement_SendAsset()
                                                                            , zc_Movement_SendOnPrice()
                                                                            , zc_Movement_Sale()
                                                                            , zc_Movement_ReturnIn()
                                                                            , zc_Movement_Loss()
                                                                            , zc_Movement_ProductionSeparate()
                                                                            , zc_Movement_ProductionUnion()
                                                                            , zc_Movement_Inventory()
                                                                            , zc_Movement_Income()
                                                                            , zc_Movement_WeighingPartner()
                                                                            , zc_Movement_WeighingProduction())
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                            LEFT JOIN tmpUnit AS tmpUnit_from ON tmpUnit_from.UnitId = MovementLinkObject_From.ObjectId
                            LEFT JOIN tmpUnit AS tmpUnit_to   ON tmpUnit_to.UnitId   = MovementLinkObject_To.ObjectId

                       WHERE  (MovementItemProtocol.UserId = inUserId OR inUserId = 0)
                          AND ( (inIsMovement = FALSE AND MovementItemProtocol.OperDate >= inStartDate AND MovementItemProtocol.OperDate < inEndDate + INTERVAL '1 DAY')
                               OR
                                (inIsMovement = TRUE AND Movement.OperDate >= inStartDate AND Movement.OperDate < inEndDate + INTERVAL '1 DAY')
                              )
                          AND (tmpUnit_from.UnitId > 0  OR tmpUnit_to.UnitId > 0)
                      )
   ------------------------
    , tmpProtocol AS (SELECT tmpMI_Protocol.*
                           , ROW_NUMBER() OVER (PARTITION BY tmpMI_Protocol.MovementItemId) AS Ord 
                      FROM tmpMI_Protocol
                          INNER JOIN tmpGoods ON tmpGoods.GoodsId = tmpMI_Protocol.GoodsId
                     ) 
    , tmpData AS (SELECT tmp1.*
                       , tmp2.GoodsId AS GoodsId_change
                       , tmp2.GoodsKindName AS GoodsKindName_change
                       , tmp2.Amount        AS Amount_change
                       , tmp2.AmountPartner AS AmountPartner_change
                       , tmp2.Price         AS Price_change
                       , tmp2.isErased      AS isErased_change
                  FROM tmpProtocol AS tmp1
                       LEFT JOIN tmpProtocol AS tmp2
				                             ON tmp2.Ord - 1 = tmp1.Ord
				                            AND tmp2.MovementItemId = tmp1.MovementItemId
                  WHERE tmp1.GoodsId <> tmp2.GoodsId
                     OR tmp1.GoodsKindName <> tmp2.GoodsKindName
                     OR tmp1.Amount <> tmp2.Amount
                     OR tmp1.AmountPartner <> tmp2.AmountPartner
                     OR tmp1.Price <> tmp2.Price
                     OR tmp1.isErased <> tmp2.isErased
                 )


     -- Результат
     SELECT tmpData.UserId
          , COALESCE (tmpUser.UserCode, Object_User.ObjectCode) ::Integer  AS UserCode
          , COALESCE (tmpUser.UserName, Object_User.ValueData)  ::TVarChar AS UserName

          , Object_Member.ValueData           AS MemberName
          , Object_Position.ValueData         AS PositionName
          , Object_Unit.Id                    AS UnitId
          , Object_Unit.ValueData             AS UnitName
          , Object_Branch.Id                  AS BranchId
          , Object_Branch.ValueData           AS BranchName

          , tmpData.MovementId
          , tmpData.MovementItemId
          , tmpData.OperDate_Protocol  ::TDateTime
          , tmpData.OperDate_Movement  ::TDateTime
          , zfConvert_StringToNumber (tmpData.Invnumber_Movement) ::Integer
          , tmpData.DescId_Movement
          , tmpData.DescName_Movement
          , Object_Status.ObjectCode          AS StatusCode
          , Object_Status.ValueData           AS StatusName

          , Object_From.ValueData             AS FromName
          , Object_To.ValueData               AS ToName

          , CASE WHEN (tmpData.DescId_Movement = zc_Movement_ProductionSeparate() AND tmpData.DescId_MovementItem = zc_MI_Master())
                     OR
                      (tmpData.DescId_Movement = zc_Movement_ProductionUnion() AND tmpData.DescId_MovementItem = zc_MI_Child())
                 THEN 'расход'
                 WHEN (tmpData.DescId_Movement = zc_Movement_ProductionSeparate() AND tmpData.DescId_MovementItem = zc_MI_Child())
                     OR
                      (tmpData.DescId_Movement = zc_Movement_ProductionUnion() AND tmpData.DescId_MovementItem = zc_MI_Master())
                 THEN 'приход'
                 ELSE ''
            END                      ::TVarChar         AS Text_inf


          , Object_Goods.ObjectCode  ::Integer          AS GoodsCode
          , Object_Goods.ValueData   ::TVarChar         AS GoodsName
          , tmpData.GoodsKindName    ::TVarChar         AS GoodsKindName

          , tmpData.Amount           ::TFloat           AS Amount
          , (CASE WHEN COALESCE (tmpData.AmountPartner, '') = '' THEN '0'  ELSE tmpData.AmountPartner END) ::TFloat AS AmountPartner
          , (CASE WHEN COALESCE (tmpData.Price, '') = '' THEN '0'  ELSE tmpData.Price END) ::TFloat AS Price

          , tmpData.IsInsert         ::Boolean          AS IsInsert
          , CASE WHEN tmpData.isErased ::Boolean = TRUE OR tmpData.StatusId_Movement = zc_Enum_Status_Erased() THEN TRUE ELSE FALSE END  ::Boolean AS isErased
          , tmpData.isErased         ::Boolean          AS isErased_Object  
          
          , Object_GoodsChange.ObjectCode::Integer  AS GoodsCode_change
          , Object_GoodsChange.ValueData ::TVarChar AS GoodsName_change
          , tmpData.GoodsKindName_change ::TVarChar AS GoodsKindName_change
          , tmpData.Amount_change        ::TFloat   AS Amount_change
          , zfConvert_StringToFloat (tmpData.AmountPartner_change) ::TFloat AS AmountPartner_change
          , zfConvert_StringToFloat (tmpData.Price_change)         ::TFloat AS Price_change
          , tmpData.isErased_change      ::Boolean  AS isErased_change

     FROM tmpData

          LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData.FromId_Movement
          LEFT JOIN Object AS Object_To ON Object_To.Id = tmpData.ToId_Movement
          LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpData.StatusId_Movement

          LEFT JOIN tmpUser ON tmpUser.UserId = tmpData.UserId
          LEFT JOIN Object AS Object_User ON Object_User.Id = tmpData.UserId

          LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpUser.MemberId
          LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpUser.PositionId
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUser.UnitId
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpUser.BranchId

          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
          
          LEFT JOIN Object AS Object_GoodsChange ON Object_GoodsChange.Id = tmpData.GoodsId_change

    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.07.22         *
*/
-- тест
-- SELECT * FROM gpReport_MIProtocolUpdate (inStartDate:= '02.07.2022' ::TDateTime, inEndDate:= '03.07.2022'::TDateTime, inUnitId:= 0, inUserId:= 0, inGoodsGroupId:= 1835, inGoodsId:= 0, inIsMovement:=TRUE, inSession:= '5'::TVarChar);


--select * from gpGet_Object_Goods(inId := 2057 ,  inSession := '9457');


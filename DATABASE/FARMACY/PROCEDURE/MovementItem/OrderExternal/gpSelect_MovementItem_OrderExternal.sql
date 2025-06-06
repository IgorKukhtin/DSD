-- Function: gpSelect_MovementItem_OrderExternal()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderExternal (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderExternal(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , CommonCode Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , PartnerGoodsId Integer, PartnerGoodsCode TVarChar, PartnerGoodsName TVarChar
             , RetailName TVarChar, AreaName TVarChar
             , NDS_PriceList TVarChar
             , Amount TFloat, Price TFloat, Summ TFloat, SummWithNDS TFloat
             , PartionGoodsDate TDateTime
             , Comment TVarChar, isErased Boolean
             , isSP     Boolean
             , isClose  Boolean
             , isFirst  Boolean
             , isSecond Boolean
             , isTOP    Boolean
             , isResolution_224 Boolean
             , PartionGoodsDateColor Integer
             , OrderShedule_Color    Integer
             , MinimumLot            TFloat
             , Multiplicity TFloat                      -- ������ �� ��������
             , CalcAmount TFloat                         
             , MultiplicityColor Integer                -- ������ �� ��������
             , isSupplierFailures Boolean
             , SupplierFailuresColor Integer
             , Layout TFloat
              )
AS
$BODY$
  DECLARE vbUserId    Integer;
  DECLARE vbPartnerId Integer;
  DECLARE vbUnitId    Integer;
  DECLARE vbDate180   TDateTime;
  DECLARE vbDate9 TDateTime;
  DECLARE vbOperDate  TDateTime;
  DECLARE vbStatusId Integer;
  DECLARE vbJuridicalId Integer;
  DECLARE vbContractId Integer;
  DECLARE vbAreaId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderExternal());
     vbUserId := inSession;
     
     --��� ������� ����� ������ ��� �����
     vbPartnerId := (SELECT MovementLinkObject_From.ObjectId
                     FROM MovementLinkObject AS MovementLinkObject_From
                     WHERE MovementLinkObject_From.MovementId = inMovementId
                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                    );

    SELECT Date_TRUNC('DAY', Movement.OperDate)
         , Movement.StatusId
         , MovementLinkObject_From.ObjectId
         , MovementLinkObject_Contract.ObjectId
         , COALESCE(ObjectLinkUnitArea.ChildObjectId, 0)
    INTO vbOperDate, vbStatusId, vbJuridicalId, vbContractId, vbAreaId
    FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                      ON MovementLinkObject_Contract.MovementId = Movement.Id
                                     AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
         LEFT JOIN ObjectLink AS ObjectLinkUnitArea 
                              ON ObjectLinkUnitArea.ObjectId = MovementLinkObject_To.ObjectId
                             AND ObjectLinkUnitArea.DescId = zc_ObjectLink_Unit_Area()
    WHERE Movement.Id =inMovementId;
    
    -- raise notice 'Value: % % %', vbJuridicalId, vbContractId, vbAreaId;

     -- + ��� ���� � ������� ��� ����������� ������ ��������
     vbDate180 := CURRENT_DATE + zc_Interval_ExpirationDate()+ zc_Interval_ExpirationDate(); --+ INTERVAL '180 DAY';  -- ����� 1 ��� (������� =6 ���.)
     vbDate9 := CURRENT_DATE + INTERVAL '9 MONTH';
   
     -- ���������
     SELECT MovementLinkObject.ObjectId AS UnitId
            INTO vbUnitId
     FROM MovementLinkObject
     
     WHERE MovementLinkObject.MovementId = inMovementId
       AND MovementLinkObject.DescId = zc_MovementLinkObject_To();

     RETURN QUERY
     WITH
     -- ������ ������ ���
     GoodsPrice AS (SELECT Price_Goods.ChildObjectId           AS GoodsId
                         , COALESCE(Price_Top.ValueData,FALSE) AS isTop
                    FROM ObjectLink AS ObjectLink_Price_Unit
                         INNER JOIN ObjectBoolean AS Price_Top
                                                  ON Price_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                 AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
                                                 AND Price_Top.ValueData = TRUE
                         LEFT JOIN ObjectLink AS Price_Goods
                                              ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                             AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                    WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                      AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                   )
   , tmpGoods AS (SELECT Object_Goods.Id          AS GoodsId
                       , Object_Goods.ObjectCode  AS GoodsCode
                       , Object_Goods.ValueData   AS GoodsName
                  FROM Object AS Object_Goods
                  WHERE Object_Goods.DescId = zc_Object_Goods() 
                    AND inShowAll = TRUE
                    AND Object_Goods.isErased = FALSE
                 )
   --
   , tmpMI_All AS (SELECT MovementItem.Id 
                        , MovementItem.PartnerGoodsCode
                        , MovementItem.PartnerGoodsId
                        , MovementItem.GoodsCode
                        , MovementItem.GoodsName
                        , MovementItem.Amount
                        , MovementItem.Price
                        , MovementItem.Summ
                        , MovementItem.isErased
                        , MovementItem.GoodsId
                        , MovementItem.PartionGoodsDate
                        , MovementItem.Comment
                        , ObjectFloat_Goods_MinimumLot.ValueData           AS MinimumLot
                        , CEIL (MovementItem.Amount / COALESCE(ObjectFloat_Goods_MinimumLot.ValueData, 1)) * COALESCE(ObjectFloat_Goods_MinimumLot.ValueData, 1)  AS CalcAmount
                        
                        
                   FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                         JOIN MovementItem_OrderExternal_View AS MovementItem 
                                                              ON MovementItem.MovementId = inMovementId
                                                             AND MovementItem.isErased   = tmpIsErased.isErased

                         LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_MinimumLot
                                                ON ObjectFloat_Goods_MinimumLot.ObjectId = MovementItem.PartnerGoodsId
                                               AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
                                               AND ObjectFloat_Goods_MinimumLot.ValueData <> 0
                                               
                  )
   , tmpMI AS (SELECT MovementItem.Id 
                    , MovementItem.PartnerGoodsCode
                    , MovementItem.PartnerGoodsId
                    , MovementItem.GoodsCode
                    , MovementItem.GoodsName
                    , MovementItem.Amount
                    , MovementItem.Price
                    , MovementItem.Summ
                    , Round(MovementItem.Amount * MovementItem.Price * 
                      (100 + COALESCE(ObjectFloat_NDSKind_NDS.ValueData, 0)) / 100, 2)    AS SummWithNDS
                    , MovementItem.isErased
                    , MovementItem.GoodsId
                    , MovementItem.PartionGoodsDate
                    , MovementItem.Comment
                    , MovementItem.MinimumLot
                    , MovementItem.CalcAmount
                    
                    
               FROM tmpMI_All AS MovementItem

                    LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.GoodsId
                    LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
 
                    LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                          ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods_Main.NDSKindId
                                         AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 
              )
   , tmpData AS (SELECT tmpMI.Id            AS Id
                      , COALESCE(tmpMI.GoodsId, tmpGoods.GoodsId)     AS GoodsId
                      , COALESCE(tmpMI.GoodsCode, tmpGoods.GoodsCode) AS GoodsCode
                      , COALESCE(tmpMI.GoodsName, tmpGoods.GoodsName) AS GoodsName
                      , tmpMI.PartnerGoodsId                          AS PartnerGoodsId 
                      , tmpMI.PartnerGoodsCode                        AS PartnerGoodsCode
                      , tmpMI.Amount                                  AS Amount
                      , tmpMI.Price                                   AS Price
                      , tmpMI.Summ::TFloat                            AS Summ
                      , tmpMI.SummWithNDS::TFloat                     AS SummWithNDS
                      , tmpMI.PartionGoodsDate                        AS PartionGoodsDate
                      , tmpMI.Comment                                 AS Comment
                      , tmpMI.MinimumLot                              AS MinimumLot
                      , tmpMI.CalcAmount                              AS CalcAmount
                      , COALESCE(tmpMI.isErased , FALSE)              AS isErased
                 FROM tmpGoods
                      FULL JOIN tmpMI ON tmpMI.GoodsId = tmpGoods.GoodsId
                 )

    -- ������ ���-������ (��������)
   , tmpGoodsSP AS (SELECT DISTINCT tmp.GoodsId, TRUE AS isSP
                   FROM lpSelect_MovementItem_GoodsSPUnit_onDate (inStartDate:= vbOperDate, inEndDate:= vbOperDate, inUnitId := vbUnitId) AS tmp
                   )

   , tmpGoodsParam AS (SELECT ObjectBoolean.*
                       FROM ObjectBoolean
                       WHERE ObjectBoolean.ObjectId IN (SELECT DISTINCT tmpData.GoodsId FROM tmpData)
                         AND ObjectBoolean.DescId IN (zc_ObjectBoolean_Goods_Close()
                                                    , zc_ObjectBoolean_Goods_TOP()
                                                    , zc_ObjectBoolean_Goods_First()
                                                    , zc_ObjectBoolean_Goods_Second())
                      )
   -- �������� ����
   , tmpObjectLink_Object AS (SELECT ObjectLink.*
                              FROM ObjectLink
                              WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpData.GoodsId FROM tmpData)
                                AND ObjectLink.DescId = zc_ObjectLink_Goods_Object()            
                             )
    , tmpObjectLink_Area AS (SELECT ObjectLink.*
                             FROM ObjectLink 
                             WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpData.PartnerGoodsId FROM tmpData)
                               AND ObjectLink.DescId = zc_ObjectLink_Goods_Area()
                            )
                                    
   , tmpMainParam AS (SELECT ObjectLink_Child.ChildObjectId                        AS GoodsId
                           , COALESCE (tmpGoodsSP.isSP, False)           ::Boolean AS isSP
                           , COALESCE (ObjectBoolean_Resolution_224.ValueData, FALSE) :: Boolean AS isResolution_224
                           , COALESCE(Object_LinkGoods_View.GoodsCode, Object_LinkGoods_View.GoodsCodeInt::TVarChar) ::Integer AS CommonCode
                      FROM ObjectLink AS ObjectLink_Child 
                           LEFT JOIN  ObjectLink AS ObjectLink_Main 
                                                 ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
           
                           LEFT JOIN  tmpGoodsSP ON tmpGoodsSP.GoodsId = ObjectLink_Main.ChildObjectId 

                           /*LEFT JOIN  ObjectBoolean AS ObjectBoolean_Goods_SP 
                                                    ON ObjectBoolean_Goods_SP.ObjectId = ObjectLink_Main.ChildObjectId 
                                                   AND ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()  */
                                                   
                           LEFT JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsmainId = ObjectLink_Main.ChildObjectId
                                                          AND Object_LinkGoods_View.ObjectId = zc_Enum_GlobalConst_Marion()
                                                          AND vbPartnerId = 59612 -- �����
                                                          AND 1=0 -- 17.01.2018 - �� ������� ������� �� ���������� �����   ������  ��������� �������  ��-�� ������ ����� �������.   ��� ��� � ��� ���� ��������  ����� ������� �� �� ����  (�� ������ �� ������ ���������) - ������ ������������� � ��������� �������.

                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Resolution_224
                                                   ON ObjectBoolean_Resolution_224.ObjectId = ObjectLink_Main.ChildObjectId
                                                  AND ObjectBoolean_Resolution_224.DescId = zc_ObjectBoolean_Goods_Resolution_224()

                      WHERE ObjectLink_Child.ChildObjectId IN (SELECT DISTINCT tmpData.GoodsId FROM tmpData)
                        AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                      )

   -- ��� �� �����-����� ���������� (LoadPriceList )
   , tmpLoadPriceList AS (SELECT *
                          FROM (SELECT LoadPriceListItem.CommonCode
                                     , LoadPriceListItem.GoodsName
                                     , LoadPriceListItem.GoodsNDS
                                     , LoadPriceListItem.GoodsId
                                     , LoadPriceListItem.ProducerName
                                     , PartnerGoods.Id AS PartnerGoodsId
                                     , ROW_NUMBER() OVER (PARTITION BY PartnerGoods.Id ORDER BY LoadPriceList.OperDate DESC, LoadPriceListItem.Id DESC) AS ORD
                                FROM LoadPriceList
                                     LEFT JOIN LoadPriceListItem ON LoadPriceListItem.LoadPriceListId = LoadPriceList.Id
                         
                                     LEFT JOIN Object_Goods_Juridical AS PartnerGoods ON PartnerGoods.JuridicalId  = LoadPriceList.JuridicalId
                                                                                     AND PartnerGoods.Code = LoadPriceListItem.GoodsCode
                                                                                    --AND COALESCE(PartnerGoods.AreaId, 0) = vbAreaId
                                WHERE LoadPriceList.JuridicalId = vbPartnerId
                                ) AS tmp
                          WHERE tmp.ORD = 1
                          )
   -- ������ �����������
   , tmpSupplierFailures AS (SELECT DISTINCT SupplierFailures.GoodsJuridicalId AS GoodsId
                             FROM gpSelect_PriceList_SupplierFailures(vbOperDate, False, inSession) AS SupplierFailures
                             WHERE SupplierFailures.JuridicalId = vbJuridicalId
                               AND SupplierFailures.ContractId = vbContractId
                               AND (COALESCE(SupplierFailures.AreaId, 0) = 0 OR COALESCE(SupplierFailures.AreaId, 0) IN 
                                     (SELECT DISTINCT tmp.AreaId_Juridical         AS AreaId
                                      FROM lpSelect_Object_JuridicalArea_byUnit (vbUnitId , 0) AS tmp
                                      WHERE tmp.JuridicalId = vbJuridicalId
                                      ))
                             )
    -- ��������       
   , tmpLayoutMovement AS (SELECT Movement.Id                                             AS Id
                                , COALESCE(MovementBoolean_PharmacyItem.ValueData, FALSE) AS isPharmacyItem
                           FROM Movement
                                LEFT JOIN MovementBoolean AS MovementBoolean_PharmacyItem
                                                          ON MovementBoolean_PharmacyItem.MovementId = Movement.Id
                                                         AND MovementBoolean_PharmacyItem.DescId = zc_MovementBoolean_PharmacyItem()
                           WHERE Movement.DescId = zc_Movement_Layout()
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                          )
  , tmpLayout AS (SELECT Movement.ID                        AS Id
                        , MovementItem.ObjectId              AS GoodsId
                        , MovementItem.Amount                AS Amount
                        , Movement.isPharmacyItem            AS isPharmacyItem
                   FROM tmpLayoutMovement AS Movement
                        INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                               AND MovementItem.DescId = zc_MI_Master()
                                               AND MovementItem.isErased = FALSE
                                               AND MovementItem.Amount > 0
                  )
  , tmpLayoutUnit AS (SELECT Movement.ID                        AS Id
                           , MovementItem.ObjectId              AS UnitId
                      FROM tmpLayoutMovement AS Movement
                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId = zc_MI_Child()
                                                  AND MovementItem.isErased = FALSE
                                                  AND MovementItem.Amount > 0
                     )
                                     
  , tmpLayoutUnitCount AS (SELECT tmpLayoutUnit.ID                  AS Id
                                , count(*)                          AS CountUnit
                           FROM tmpLayoutUnit
                           GROUP BY tmpLayoutUnit.ID
                           )
  , tmpLayoutAll AS (SELECT tmpLayout.GoodsId                  AS GoodsId
                          , MAX(tmpLayout.Amount)::TFloat      AS Amount
                     FROM tmpLayout
                                 
                          LEFT JOIN ObjectBoolean AS Unit_PharmacyItem
                                                  ON Unit_PharmacyItem.ObjectId  = vbUnitId
                                                 AND Unit_PharmacyItem.DescId    = zc_ObjectBoolean_Unit_PharmacyItem()
                                       
                          LEFT JOIN tmpLayoutUnit ON tmpLayoutUnit.Id     = tmpLayout.Id
                                                 AND tmpLayoutUnit.UnitId = vbUnitId

                          LEFT JOIN tmpLayoutUnitCount ON tmpLayoutUnitCount.Id     = tmpLayout.Id
                                       
                     WHERE (tmpLayoutUnit.UnitId = vbUnitId OR COALESCE (tmpLayoutUnitCount.CountUnit, 0) = 0)
                       AND (COALESCE (Unit_PharmacyItem.ValueData, False) = False OR tmpLayout.isPharmacyItem = True)
                     GROUP BY tmpLayout.GoodsId 
                     )
                             

       SELECT
             tmpMI.Id
           , tmpMainParam.CommonCode
           , tmpMI.GoodsId
           , tmpMI.GoodsCode
           , tmpMI.GoodsName
           , tmpMI.PartnerGoodsId
           , COALESCE(MIString_GoodsCode.ValueData, tmpMI.PartnerGoodsCode)        AS PartnerGoodsCode
           , COALESCE(MIString_GoodsName.ValueData, Object_PartnerGoods.ValueData) AS PartnerGoodsName
           , Object_Retail.ValueData    AS RetailName
           , Object_Area.ValueData      AS AreaName
           , CASE WHEN COALESCE (tmpLoadPriceList.GoodsNDS,'0') <> '0' THEN COALESCE (tmpLoadPriceList.GoodsNDS,'') ELSE '' END  :: TVarChar  AS NDS_PriceList                                                               -- ��� �� ������ ����������
           , tmpMI.Amount               AS Amount
           , tmpMI.Price                AS Price
           , tmpMI.Summ ::TFloat        AS Summ
           , tmpMI.SummWithNDS ::TFloat AS SummWithNDS
           
           , tmpMI.PartionGoodsDate     AS PartionGoodsDate
           , tmpMI.Comment              AS Comment
           , tmpMI.isErased             AS isErased
           , COALESCE (tmpMainParam.isSP, FALSE)           ::Boolean AS isSP
           , COALESCE (GoodsParam_Close.ValueData, FALSE)  ::Boolean AS isClose
           , COALESCE (GoodsParam_First.ValueData, FALSE)  ::Boolean AS isFirst
           , COALESCE (GoodsParam_Second.ValueData, FALSE) ::Boolean AS isSecond
           , COALESCE (GoodsPrice.isTop, GoodsParam_TOP.ValueData, FALSE) ::Boolean AS isTOP
           , COALESCE (tmpMainParam.isResolution_224, FALSE) :: Boolean AS isResolution_224

           , CASE WHEN tmpMainParam.isSP = TRUE THEN 25088                                                          -- ����� ���.�������
               WHEN tmpMI.PartionGoodsDate < CASE WHEN COALESCE (tmpLayoutAll.Amount, 0) > 0 THEN vbDate9 ELSE vbDate180 END THEN zc_Color_Red()                                          -- ���� ���� �������� ����� 6 ���.
               WHEN COALESCE (GoodsPrice.isTop, GoodsParam_TOP.ValueData, FALSE) = TRUE THEN zc_Color_Blue()        --15993821 -- 16440317    -- ��� ��� �������
               ELSE 0
             END                                                 AS PartionGoodsDateColor
           , CASE
                  WHEN COALESCE(MIString_GoodsName.ValueData, Object_PartnerGoods.ValueData) ILIKE '%�+%' AND vbJuridicalId = 410822 
                    OR (COALESCE(MIString_GoodsName.ValueData, Object_PartnerGoods.ValueData) ILIKE '%ANC%' 
                    OR COALESCE(MIString_GoodsName.ValueData, Object_PartnerGoods.ValueData) ILIKE '%PL/%') AND vbJuridicalId = 59612
                    OR COALESCE(MIString_GoodsName.ValueData, Object_PartnerGoods.ValueData) ILIKE '%����%'
                    OR COALESCE(MIString_GoodsName.ValueData, Object_PartnerGoods.ValueData) ILIKE '%��²%'
                    OR tmpMI.GoodsName ILIKE '%���%' THEN zc_Color_Red()    --������� ���������� ������
                  WHEN COALESCE (GoodsParam_Close.ValueData, FALSE) = TRUE THEN zfCalc_Color (250, 128, 114) 
                  ELSE zc_Color_White()
              END  AS OrderShedule_Color
           , tmpMI.MinimumLot  ::TFloat                           AS MinimumLot
           , tmpMI.MinimumLot  ::TFloat                           AS Multiplicity
           , tmpMI.CalcAmount  ::TFloat                           AS CalcAmount
           , CASE
                  WHEN COALESCE (tmpMI.MinimumLot <> 0) AND tmpMI.CalcAmount <> tmpMI.Amount THEN zc_Color_Red() --������� ���������� ������
                  WHEN COALESCE (GoodsParam_Close.ValueData, FALSE) = TRUE THEN zfCalc_Color (250, 128, 114) 
                  ELSE zc_Color_White()
              END  AS MultiplicityColor
           , COALESCE (SupplierFailures.GoodsId, 0) <> 0          AS isSupplierFailures
           , CASE
                  WHEN COALESCE (SupplierFailures.GoodsId, 0) <> 0 THEN zfCalc_Color (255, 165, 0) -- orange 
                  WHEN COALESCE (GoodsParam_Close.ValueData, FALSE) = TRUE THEN zfCalc_Color (250, 128, 114) 
                  ELSE zc_Color_White()
              END  AS SupplierFailuresColor
           , tmpLayoutAll.Amount::TFloat                                     AS Layout
      
       FROM tmpData AS tmpMI
            -- �������� ����
            LEFT JOIN  tmpObjectLink_Object AS ObjectLink_Object 
                                            ON ObjectLink_Object.ObjectId = tmpMI.GoodsId
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Object.ChildObjectId
            -- ������
            LEFT JOIN tmpObjectLink_Area AS ObjectLink_Goods_Area
                                         ON ObjectLink_Goods_Area.ObjectId = tmpMI.PartnerGoodsId
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId
            --
            LEFT JOIN tmpMainParam ON tmpMainParam.GoodsId = tmpMI.GoodsId
            
            LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = tmpMI.GoodsId
            
            LEFT JOIN tmpGoodsParam AS GoodsParam_Close 
                                    ON GoodsParam_Close.ObjectId = tmpMI.GoodsId
                                   AND GoodsParam_Close.DescId = zc_ObjectBoolean_Goods_Close()
            LEFT JOIN tmpGoodsParam AS GoodsParam_First 
                                    ON GoodsParam_First.ObjectId = tmpMI.GoodsId
                                   AND GoodsParam_First.DescId = zc_ObjectBoolean_Goods_First()
            LEFT JOIN tmpGoodsParam AS GoodsParam_Second
                                    ON GoodsParam_Second.ObjectId = tmpMI.GoodsId
                                   AND GoodsParam_Second.DescId = zc_ObjectBoolean_Goods_Second()
            LEFT JOIN tmpGoodsParam AS GoodsParam_TOP
                                    ON GoodsParam_TOP.ObjectId = tmpMI.GoodsId
                                   AND GoodsParam_TOP.DescId = zc_ObjectBoolean_Goods_TOP()
           
            LEFT JOIN tmpLoadPriceList ON tmpLoadPriceList.PartnerGoodsId = tmpMI.PartnerGoodsId
            LEFT JOIN Object AS Object_PartnerGoods ON Object_PartnerGoods.Id = tmpMI.PartnerGoodsId

            LEFT JOIN MovementItemString AS MIString_GoodsCode 
                                         ON MIString_GoodsCode.MovementItemId = tmpMI.Id
                                        AND MIString_GoodsCode.DescId = zc_MIString_GoodsCode()     
                                        AND vbStatusId = zc_Enum_Status_Complete()                              
            LEFT JOIN MovementItemString AS MIString_GoodsName 
                                         ON MIString_GoodsName.MovementItemId = tmpMI.Id
                                        AND MIString_GoodsName.DescId = zc_MIString_GoodsName()                                  
                                        AND vbStatusId = zc_Enum_Status_Complete() 
                                        
            LEFT JOIN tmpSupplierFailures AS SupplierFailures 
                                          ON SupplierFailures.GoodsId = tmpMI.PartnerGoodsId

            LEFT JOIN tmpLayoutAll ON tmpLayoutAll.GoodsId = tmpMI.GoodsId 
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.04.20         * isResolution_224
 22.04.20         * tmpLoadPriceList.GoodsNDS
 11.02.19         * ������� ������ ���-������ ����� � ���������
 08.11.18         *
 21.10.17         * add AreaName
 25.09.17         *
 06.04.17         * add isSp
 12.12.14                         *
 06.11.14                         *
 20.10.14                         *
 15.07.14                                                       *
 01.07.14                                                       *

*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_OrderExternal (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_OrderExternal (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
--

select * from gpSelect_MovementItem_OrderExternal(inMovementId := 31044249 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');
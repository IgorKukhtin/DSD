-- Function: gpSelect_GoodsSearchRemains_1303()

DROP FUNCTION IF EXISTS gpSelect_GoodsSearchRemains_1303 (TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsSearchRemains_1303(
    IN inCodeSearch        TVarChar,    -- ����� ������� �� ����
    IN inGoodsSearch       TVarChar,    -- ����� �������
    IN inPartnerMedicalID  Integer,     -- ��������
    IN inSession           TVarChar     -- ������ ������������
)
RETURNS TABLE (Id integer, GoodsCode Integer, GoodsName TVarChar
             , NDSkindName TVarChar
             , NDS TFloat
             , GoodsGroupName TVarChar
             , UnitId integer, UnitName TVarChar
             , PartnerMedicalName TVarChar
             , Address_Unit TVarChar
             , Phone_Unit TVarChar
             , ProvinceCityName_Unit TVarChar
             , JuridicalName_Unit TVarChar
             , PriceOptSP_1303 TFloat
             , PriceSale_1303 TFloat
             , Amount TFloat
             , AmountIncome TFloat
             , AmountReserve TFloat
             , PriceSale  TFloat
             , SummaSale TFloat
             , DateChange TDateTime
             , MinExpirationDate TDateTime
             , Price_min_NDS TFloat
             , Price_min TFloat
             , PriceSaleIncome TFloat
             , IntenalSPId   Integer 
             , IntenalSPName TVarChar
             , BrandSPId     Integer 
             , BrandSPName   TVarChar
             , isOrder408    Boolean
             , Color_calc Integer
             , ColorMinPrice_calc Integer
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbRemainsDate TDateTime;
   DECLARE vbisAdmin Boolean;
   DECLARE vbDeviationsPrice1303 TFloat;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- ����������� �� �������� ��������� �����������
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    vbRemainsDate = CURRENT_TIMESTAMP;
    vbisAdmin := EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
                 AND vbUserId NOT IN (183242);

    SELECT COALESCE(ObjectFloat_CashSettings_DeviationsPrice1303.ValueData, 1)    AS DeviationsPrice1303
    INTO vbDeviationsPrice1303
    FROM Object AS Object_CashSettings
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_DeviationsPrice1303
                               ON ObjectFloat_CashSettings_DeviationsPrice1303.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_DeviationsPrice1303.DescId = zc_ObjectFloat_CashSettings_DeviationsPrice1303()
    WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
    LIMIT 1;

    -- ���������
    RETURN QUERY
        WITH
        tmpGoods1303 AS (select * from gpSelect_GoodsSPRegistry_1303_All(inSession := inSession))
      , tmpGoods AS (SELECT Goods_Retail.Id
                          , Goods_Main.ObjectCode
                          , Goods_Main.Name
                          , Goods_Main.GoodsGroupId
                          , Goods_Main.NDSKindId

                          , COALESCE (Object_IntenalSP.Id ,0)          ::Integer  AS IntenalSPId
                          , COALESCE (Object_IntenalSP.ValueData,'')   ::TVarChar AS IntenalSPName
                          , COALESCE (Object_BrandSP.Id ,0)            ::Integer  AS BrandSPId
                          , COALESCE (Object_BrandSP.ValueData,'')     ::TVarChar AS BrandSPName
                     FROM Object_Goods_Main AS Goods_Main
                          INNER JOIN Object_Goods_Retail AS Goods_Retail
                                                         ON Goods_Main.Id  = Goods_Retail.GoodsMainId
                                                        AND Goods_Retail.RetailId = vbObjectId 
                          INNER JOIN tmpGoods1303 ON tmpGoods1303.GoodsId = Goods_Retail.Id

                          LEFT JOIN MovementItemLinkObject AS MI_IntenalSP
                                                           ON MI_IntenalSP.MovementItemId = tmpGoods1303.MovementItemId
                                                          AND MI_IntenalSP.DescId = zc_MILinkObject_IntenalSP_1303()
                          LEFT JOIN Object AS Object_IntenalSP ON Object_IntenalSP.Id = MI_IntenalSP.ObjectId 

                          LEFT JOIN MovementItemLinkObject AS MI_BrandSP
                                                           ON MI_BrandSP.MovementItemId = tmpGoods1303.MovementItemId
                                                          AND MI_BrandSP.DescId = zc_MILinkObject_BrandSP()
                          LEFT JOIN Object AS Object_BrandSP ON Object_BrandSP.Id = MI_BrandSP.ObjectId 

                     WHERE (','||inCodeSearch||',' ILIKE '%,'||CAST(Goods_Main.ObjectCode AS TVarChar)||',%' AND inCodeSearch <> '')
                        OR (upper(Goods_Main.Name) ILIKE UPPER('%'||inGoodsSearch||'%')  AND inGoodsSearch <> '' AND inCodeSearch = '')
                        OR (MI_IntenalSP.ObjectId in (SELECT Object_IntenalSP.Id        
                                                      FROM OBJECT AS Object_IntenalSP
                                                      WHERE Object_IntenalSP.DescId = zc_Object_IntenalSP_1303()
                                                        AND upper(Object_IntenalSP.ValueData) ILIKE UPPER('%'||inGoodsSearch||'%')) AND inGoodsSearch <> '' AND inCodeSearch = '')
                        OR (MI_BrandSP.ObjectId  in (SELECT Object_BrandSP.Id        
                                                     FROM OBJECT AS Object_BrandSP
                                                     WHERE Object_BrandSP.DescId = zc_Object_BrandSP()
                                                       AND upper(Object_BrandSP.ValueData) ILIKE UPPER('%'||inGoodsSearch||'%')) AND inGoodsSearch <> '' AND inCodeSearch = '')

                    --    OR (upper(Object_IntenalSP.ValueData) ILIKE UPPER('%'||inGoodsSearch||'%')  AND inGoodsSearch <> '' AND inCodeSearch = '')
                    --    OR (upper(Object_BrandSP.ValueData) ILIKE UPPER('%'||inGoodsSearch||'%')  AND inGoodsSearch <> '' AND inCodeSearch = '')
                     )

      , containerAll AS (SELECT Container.descid
                              , Container.Id                AS ContainerId
                              , Container.ParentId
                              , Container.Amount
                              , Container.ObjectID          AS GoodsId
                              , Container.WhereObjectId     AS UnitId
                         FROM Container
                         WHERE Container.ObjectID in (SELECT tmpGoods.Id FROM tmpGoods)
                           AND Container.descid IN (zc_Container_Count(), zc_Container_CountPartionDate())
                           AND Container.whereobjectid IN (SELECT T1.ID FROM gpSelect_Object_Unit(False, False, '3') AS T1)
                         )
      , containerPD AS (SELECT Container.ParentId
                             , MIN(COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd()))  AS ExpirationDate
                        FROM containerAll AS Container

                             LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.ContainerId
                                                          AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                             LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                  ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId 
                                                 AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                                 
                        WHERE Container.DescId = zc_Container_CountPartionDate()
                          AND Container.Amount > 0
                        GROUP BY Container.ParentId
                         )
      , containerCount AS (SELECT Container.ContainerId       AS ContainerId
                                , Container.Amount
                                , Container.GoodsId           AS GoodsId
                                , Container.UnitId            AS UnitId
                           FROM containerAll AS Container
                           WHERE Container.descid = zc_container_count()
                           )

      , tmpMIC AS (SELECT MIContainer.ContainerId
                        , MIContainer.Amount
                        , MIContainer.MovementDescId
                   FROM MovementItemContainer AS MIContainer
                   WHERE MIContainer.ContainerId IN (SELECT ContainerCount.ContainerId FROM ContainerCount)
                     AND MIContainer.OperDate >= CURRENT_TIMESTAMP - INTERVAL '1 day'
                     AND MIContainer.MovementDescId in (zc_Movement_Check(), zc_Movement_Sale())
                      )

      , tmpCLO AS (SELECT * FROM ContainerlinkObject  AS ContainerLinkObject_MovementItem
                   WHERE ContainerLinkObject_MovementItem.Containerid IN (SELECT containerCount.ContainerId FROM containerCount))

      , tmpData_Inc AS (SELECT containerCount.Amount
                             , containerCount.GoodsId
                             , containerCount.UnitId
                             , COALESCE (MIFloat_MovementItem.ValueData :: Integer,Object_PartionMovementItem.ObjectCode)    AS MI_Income
                             , containerPD.ExpirationDate
                        FROM containerCount

                            -- ������� ������ ��� ����������� ����� �������� �������
                            LEFT JOIN tmpCLO AS ContainerLinkObject_MovementItem
                                                          ON ContainerLinkObject_MovementItem.Containerid =  containerCount.ContainerId
                                                         AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                            LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                            -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                            LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                        ON MIFloat_MovementItem.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                                       
                            LEFT JOIN containerPD ON containerPD.ParentId = containerCount.ContainerId
                        WHERE containerCount.Amount > 0
                        )
      , tmpMID AS (SELECT * FROM MovementItemDate  AS MIDate_ExpirationDate
                   WHERE MIDate_ExpirationDate.MovementItemId IN (SELECT tmpData_Inc.MI_Income FROM tmpData_Inc))

      , tmpData_all AS (SELECT SUM(tmpData_Inc.Amount)    AS Amount
                             , tmpData_Inc.GoodsId
                             , tmpData_Inc.UnitId
                             , min (COALESCE(tmpData_Inc.ExpirationDate, MIDate_ExpirationDate.ValueData, zc_DateEnd()))::TDateTime AS MinExpirationDate -- ���� ��������
                        FROM tmpData_Inc

                            LEFT OUTER JOIN tmpMID  AS MIDate_ExpirationDate
                                                              ON MIDate_ExpirationDate.MovementItemId = tmpData_Inc.MI_Income
                                                             AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                        GROUP BY tmpData_Inc.GoodsId, tmpData_Inc.UnitId
                        )
      , tmpData AS (SELECT tmpData_all.UnitId
                         , tmpData_all.GoodsId
                         , SUM (tmpData_all.Amount)   AS Amount
                         , min (tmpData_all.MinExpirationDate) AS MinExpirationDate
                    FROM  tmpData_all
                    GROUP BY tmpData_all.GoodsId
                           , tmpData_all.UnitId
                    HAVING (SUM (tmpData_all.Amount) <> 0)
                    )

      , tmpIncome AS (SELECT MovementLinkObject_To.ObjectId          AS UnitId
                           , MI_Income.ObjectId                      AS GoodsId
                           , SUM(COALESCE (MI_Income.Amount, 0))     AS AmountIncome
                           , SUM(COALESCE (MI_Income.Amount, 0) * COALESCE(MIFloat_PriceSale.ValueData,0))  AS SummSale
                      FROM Movement AS Movement_Income
                           INNER JOIN MovementDate AS MovementDate_Branch
                                                   ON MovementDate_Branch.MovementId = Movement_Income.Id
                                                  AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
                                                  AND date_trunc('day', MovementDate_Branch.ValueData) between date_trunc('day', CURRENT_TIMESTAMP)-interval '1 month' AND date_trunc('day', CURRENT_TIMESTAMP)

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                           LEFT JOIN MovementItem AS MI_Income
                                                  ON MI_Income.MovementId = Movement_Income.Id
                                                 AND MI_Income.isErased   = False

                           LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                       ON MIFloat_PriceSale.MovementItemId = MI_Income.Id
                                                      AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

                           -- left join  Object ON Object.id = MI_Income.ObjectId
                           -- left join  Object AS Object1 ON Object1.id = MovementLinkObject_To.ObjectId
                       WHERE Movement_Income.DescId = zc_Movement_Income()
                         AND Movement_Income.StatusId = zc_Enum_Status_UnComplete()
                       GROUP BY MI_Income.ObjectId
                              , MovementLinkObject_To.ObjectId
                    )

          -- ���������� ����
      , tmpMovementID AS (SELECT
                                 Movement.Id
                               , Movement.DescId
                          FROM Movement
                          WHERE Movement.DescId = zc_Movement_Check()
                            AND Movement.StatusId = zc_Enum_Status_UnComplete()
                            AND Movement.OperDate > CURRENT_DATE - INTERVAL '100 DAY'
                        )
       -- ���������� ����
      , tmpMovReserve AS (SELECT Movement.Id
                               , MovementLinkObject_Unit.ObjectId AS UnitId
                          FROM MovementBoolean AS MovementBoolean_Deferred
                             INNER JOIN tmpMovementID AS Movement 
                                                      ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                     AND Movement.DescId = zc_Movement_Check()
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                          WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                            AND MovementBoolean_Deferred.ValueData = TRUE
                         UNION ALL
                          SELECT Movement.Id
                               , MovementLinkObject_Unit.ObjectId AS UnitId
                          FROM MovementString AS MovementString_CommentError
                             INNER JOIN tmpMovementID AS Movement 
                                                      ON Movement.Id     = MovementString_CommentError.MovementId
                                                     AND Movement.DescId = zc_Movement_Check()
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                         WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                           AND MovementString_CommentError.ValueData <> ''
                         )
      , tmpReserve AS (SELECT tmpMovReserve.UnitId             AS UnitId
                            , MovementItem.ObjectId            AS GoodsId
                            , Sum(MovementItem.Amount)::TFloat AS Amount
                       FROM tmpMovReserve
                            INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovReserve.Id
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = FALSE
                       GROUP BY MovementItem.ObjectId, tmpMovReserve.UnitId
                       )



      , tmpUnitAll AS (SELECT *
                       FROM Object AS Object_Unit
                       WHERE Object_Unit.DescId = zc_Object_Unit()
                         AND Object_Unit.isErased = False
                         AND Object_Unit.ValueData NOT ILIKE '�������%'
                         AND Object_Unit.ValueData NOT ILIKE '��������%'
                       )
      , tmpObjectLink AS (SELECT *
                          FROM ObjectLink
                          WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpUnitAll.Id FROM tmpUnitAll)
                          )
      , tmpUnit AS (SELECT Object_Unit.Id                               AS UnitId
                         , Object_Unit.ValueData                        AS UnitName
                         , Object_Area.ValueData                        AS AreaName
                         , Object_Retail.ValueData                      AS RetailName
                         , Object_ProvinceCity.ValueData                AS ProvinceCityName_Unit
                         , Object_Juridical.ValueData                   AS JuridicalName_Unit
                         , ObjectString_Unit_Address.ValueData          AS Address_Unit
                         , ObjectString_Unit_Phone.ValueData            AS Phone_Unit
                         , Object_PartnerMedical.Id                     AS PartnerMedicalId
                         , Object_PartnerMedical.ValueData              AS PartnerMedicalName
                         , ObjectLink_Unit_Area.ChildObjectId           AS AreaId
                    FROM tmpUnitAll AS Object_Unit
                         INNER JOIN tmpObjectLink AS ObjectLink_Unit_PartnerMedical
                                                  ON ObjectLink_Unit_PartnerMedical.ObjectId = Object_Unit.Id 
                                                 AND ObjectLink_Unit_PartnerMedical.DescId = zc_ObjectLink_Unit_PartnerMedical()
                         LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = ObjectLink_Unit_PartnerMedical.ChildObjectId
                         
                         LEFT JOIN tmpObjectLink AS ObjectLink_Unit_Area
                                                 ON ObjectLink_Unit_Area.ObjectId = Object_Unit.Id
                                                AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
                         LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Unit_Area.ChildObjectId

                         LEFT JOIN tmpObjectLink AS ObjectLink_Unit_Juridical
                                                 ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

                         LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                         LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

                         LEFT JOIN tmpObjectLink AS ObjectLink_Unit_ProvinceCity
                                                 ON ObjectLink_Unit_ProvinceCity.ObjectId = Object_Unit.Id
                                                AND ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
                         LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = ObjectLink_Unit_ProvinceCity.ChildObjectId

                         LEFT JOIN ObjectString AS ObjectString_Unit_Address
                                                ON ObjectString_Unit_Address.ObjectId = Object_Unit.Id
                                               AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()
                         LEFT JOIN ObjectString AS ObjectString_Unit_Phone
                                                ON ObjectString_Unit_Phone.ObjectId = Object_Unit.Id
                                               AND ObjectString_Unit_Phone.DescId = zc_ObjectString_Unit_Phone()

                         LEFT JOIN ObjectLink AS ContactPerson_ContactPerson_Object
                                              ON ContactPerson_ContactPerson_Object.ChildObjectId = Object_Unit.Id
                                             AND ContactPerson_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()

                    WHERE ObjectLink_Unit_PartnerMedical.ChildObjectId = COALESCE(inPartnerMedicalID, 0) OR 
                          COALESCE(inPartnerMedicalID, 0) = 0 AND COALESCE(ObjectLink_Unit_PartnerMedical.ChildObjectId, 0) <> 0
                    )

      , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                            , ObjectFloat_NDSKind_NDS.ValueData
                      FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                      WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                      )
      , tmpGoodsParams AS (SELECT tmpGoods.Id                                      AS GoodsId
                                , tmpGoods.ObjectCode                              AS GoodsCode
                                , tmpGoods.Name                                    AS GoodsName
                                , Object_GoodsGroup.ValueData                      AS GoodsGroupName
                                , Object_NDSKind.ValueData                         AS NDSKindName
                                , ObjectFloat_NDSKind_NDS.ValueData                AS NDS
                               FROM tmpGoods

                                 LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpGoods.GoodsGroupId

                                 LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = tmpGoods.NDSKindId

                                 LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                      ON ObjectFloat_NDSKind_NDS.ObjectId = tmpGoods.NDSKindId
                           )

      , tmpPrice AS (SELECT Price_Goods.ObjectId        AS Id
                          , Price_Goods.ChildObjectId   AS GoodsId
                     FROM ObjectLink AS Price_Goods
                     WHERE Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                       AND Price_Goods.ChildObjectId IN (SELECT tmpGoods.Id FROM tmpGoods )
                    )
      , tmpPrice_View AS (SELECT Price_Goods.Id              AS Id
                               , Price_Unit.ChildObjectId    AS UnitId
                               , Price_Goods.GoodsId         AS GoodsId
                               , CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                       AND ObjectFloat_Goods_Price.ValueData > 0
                                      THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                      ELSE ROUND (Price_Value.ValueData, 2)
                                 END :: TFloat                           AS Price
                               , Price_DateChange.ValueData              AS DateChange 
                               , COALESCE (ObjectBoolean_Top.ValueData, FALSE)     AS isTOP
                               , COALESCE (ObjectFloat_PercentMarkup.ValueData, 0) AS PercentMarkup
                               , MCS_Value.ValueData                               AS MCSValue
                          FROM tmpPrice AS Price_Goods
                               LEFT JOIN ObjectLink AS Price_Unit
                                      ON Price_Unit.ObjectId = Price_Goods.Id
                                     AND Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                               LEFT JOIN ObjectFloat AS Price_Value
                                                     ON Price_Value.ObjectId = Price_Unit.ObjectId
                                                    AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                               LEFT JOIN ObjectDate AS Price_DateChange
                                                    ON Price_DateChange.ObjectId = Price_Unit.ObjectId
                                                   AND Price_DateChange.DescId = zc_ObjectDate_Price_DateChange()
                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                                       ON ObjectBoolean_Top.ObjectId  = Price_Unit.ObjectId
                                                      AND ObjectBoolean_Top.DescId    = zc_ObjectBoolean_Price_Top()
                               LEFT JOIN ObjectFloat AS ObjectFloat_PercentMarkup
                                                     ON ObjectFloat_PercentMarkup.ObjectId = Price_Unit.ObjectId
                                                    AND ObjectFloat_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
                               LEFT JOIN ObjectFloat AS MCS_Value
                                                     ON MCS_Value.ObjectId = Price_Unit.ObjectId
                                                    AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                                 -- ���� ���� ��� ���� ����
                               LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                      ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.GoodsId
                                                     AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                       ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.GoodsId
                                                      AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                          )
      , tmpMinPrice_List AS (SELECT MinPriceList.GoodsId,
                                    MinPriceList.GoodsCode,
                                    MinPriceList.GoodsName,
                                    MinPriceList.PartionGoodsDate,
                                    MinPriceList.Partner_GoodsId,
                                    MinPriceList.Partner_GoodsCode,
                                    MinPriceList.Partner_GoodsName,
                                    MinPriceList.MakerName,
                                    MinPriceList.ContractId,
                                    MinPriceList.AreaId,
                                    MinPriceList.JuridicalId,
                                    MinPriceList.JuridicalName,
                                    MinPriceList.Price,
                                    MinPriceList.SuperFinalPrice,
                                    MinPriceList.isTop,
                                    MinPriceList.isOneJuridical
                                FROM tmpGoods
                                     INNER JOIN MinPrice_ForSite AS MinPriceList
                                                                 ON tmpGoods.Id = MinPriceList.GoodsId
                                WHERE MinPriceList.JuridicalId IN (59610, 59611, 59612))
       , tmpIncome_All AS (SELECT Container.ObjectId                                          AS GoodsId
                                , Container.WhereObjectId                                     AS UnitId
                                , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)   AS MovementId
                                , MovementLinkObject_To.ObjectId                              AS UnitInId
                            FROM Container 
                                 INNER JOIN ContainerLinkObject AS CLI_MI 
                                                                ON CLI_MI.ContainerId = Container.Id
                                                               AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                 INNER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId

                                 INNER JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode :: Integer
                                 -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                                 LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                             ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                            AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                 -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                                 LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON MovementLinkObject_To.MovementId = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()   

                              WHERE Container.ObjectId IN (SELECT tmpGoods.Id FROM tmpGoods)
                                AND Container.DescId = zc_Container_Count()
                                AND Container.WhereObjectId IN (SELECT tmpUnit.UnitId FROM tmpUnit)
                                AND Container.ID > 10000000
                              )
       , tmpIncome_Last AS (SELECT tmpIncome_All.GoodsId
                                 , tmpIncome_All.UnitId
                                 , tmpIncome_All.MovementId
                                 , ROW_NUMBER() OVER (PARTITION BY tmpIncome_All.UnitId, tmpIncome_All.GoodsId ORDER BY tmpIncome_All.UnitInId <> tmpIncome_All.UnitId, tmpIncome_All.MovementId DESC) AS ord   -- ���� ������� �������� �� ��������� ������
                             FROM tmpIncome_All                                
                             )
       , tmpIncome_1303 AS (SELECT tmpIncome_Last.GoodsId
                                 , tmpIncome_Last.UnitId
                                 , Max(COALESCE(MIFloat_PriceSample.ValueData, 
                                       CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE THEN MIFloat_Price.ValueData
                                            ELSE (MIFloat_Price.ValueData * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData,1)/100))::TFloat 
                                            END) * 1.1)::TFloat    AS PriceSale   -- ���� ��������� 1303
                            FROM tmpIncome_Last 
                            
                                 LEFT JOIN MovementItem ON MovementItem.MovementId =  tmpIncome_Last.MovementId
                                                       AND MovementItem.ObjectId = tmpIncome_Last.GoodsId

                                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                 LEFT JOIN MovementItemFloat AS MIFloat_PriceSample
                                                             ON MIFloat_PriceSample.MovementItemId = MovementItem.Id
                                                            AND MIFloat_PriceSample.DescId = zc_MIFloat_PriceSample()

                                 LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                           ON MovementBoolean_PriceWithVAT.MovementId =  tmpIncome_Last.MovementId
                                                          AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                              ON MovementLinkObject_NDSKind.MovementId = tmpIncome_Last.MovementId
                                                             AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                 LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                      ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId

                              WHERE tmpIncome_Last.ord = 1
                              GROUP BY tmpIncome_Last.GoodsId
                                     , tmpIncome_Last.UnitId
                              )
       , tmpObject_MarginCategoryLink AS (SELECT ObjectLink_MarginCategoryLink_MarginCategory.ObjectId      AS Id
                                               , ObjectLink_MarginCategoryLink_MarginCategory.ChildObjectId AS MarginCategoryId
                                               , ObjectLink_MarginCategoryLink_Unit.ChildObjectId           AS UnitId
                                               , ObjectLink_MarginCategoryLink_Juridical.ChildObjectId      AS JuridicalId
                                               , Object_MarginCategoryLink.isErased                         AS isErased

                                         FROM ObjectLink AS ObjectLink_MarginCategoryLink_MarginCategory
                                               LEFT JOIN Object AS Object_MarginCategoryLink ON Object_MarginCategoryLink.Id = ObjectLink_MarginCategoryLink_MarginCategory.ObjectId
                                               LEFT JOIN Object AS Object_MarginCategory ON Object_MarginCategory.Id = ObjectLink_MarginCategoryLink_MarginCategory.ChildObjectId

                                               LEFT JOIN ObjectLink AS ObjectLink_MarginCategoryLink_Unit
                                                                    ON ObjectLink_MarginCategoryLink_Unit.ObjectId = ObjectLink_MarginCategoryLink_MarginCategory.ObjectId
                                                                   AND ObjectLink_MarginCategoryLink_Unit.DescId = zc_ObjectLink_MarginCategoryLink_Unit()
                                               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_MarginCategoryLink_Unit.ChildObjectId
                                                       
                                               LEFT JOIN ObjectLink AS ObjectLink_MarginCategoryLink_Juridical
                                                                    ON ObjectLink_MarginCategoryLink_Juridical.ObjectId = ObjectLink_MarginCategoryLink_MarginCategory.ObjectId
                                                                   AND ObjectLink_MarginCategoryLink_Juridical.DescId = zc_ObjectLink_MarginCategoryLink_Juridical()
                                               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_MarginCategoryLink_Juridical.ChildObjectId

                                         WHERE ObjectLink_MarginCategoryLink_MarginCategory.DescId = zc_ObjectLink_MarginCategoryLink_MarginCategory()
                                           AND Object_MarginCategoryLink.isErased    = FALSE
                                         )
       , DD AS (SELECT DISTINCT
                       Object_MarginCategoryItem_View.MarginPercent,
                       Object_MarginCategoryItem_View.MinPrice,
                       Object_MarginCategoryItem_View.MarginCategoryId,
                       ROW_NUMBER()OVER(PARTITION BY Object_MarginCategoryItem_View.MarginCategoryId ORDER BY Object_MarginCategoryItem_View.MinPrice) as ORD
                FROM Object_MarginCategoryItem_View
                     INNER JOIN Object AS Object_MarginCategoryItem ON Object_MarginCategoryItem.Id = Object_MarginCategoryItem_View.Id
                                                                       AND Object_MarginCategoryItem.isErased = FALSE
                )
       , MarginCondition AS (SELECT D1.MarginCategoryId,
                                    D1.MarginPercent,
                                    D1.MinPrice,
                                    COALESCE(D2.MinPrice, 1000000) AS MaxPrice
                             FROM DD AS D1
                                  LEFT OUTER JOIN DD AS D2 ON D1.MarginCategoryId = D2.MarginCategoryId AND D1.ORD = D2.ORD-1)
       , tmpResult AS  (SELECT tmpGoodsParams.GoodsId
                             , tmpGoodsParams.GoodsCode
                             , tmpGoodsParams.GoodsName
                             , tmpGoodsParams.NDSkindName
                             , tmpGoodsParams.NDS
                             , tmpGoodsParams.GoodsGroupName
                             , Object_Unit.UnitId
                             , Object_Unit.UnitName
                             , Object_Unit.PartnerMedicalName
                             , Object_Unit.Address_Unit
                             , Object_Unit.Phone_Unit
                             , Object_Unit.ProvinceCityName_Unit
                             , Object_Unit.JuridicalName_Unit
                             , tmpGoods1303.PriceOptSP                                                         AS PriceOptSP_1303
                             , tmpGoods1303.PriceSale                                                          AS PriceSale_1303
                             , tmpData.Amount                                                        :: TFloat AS Amount
                             , COALESCE (tmpIncome.AmountIncome,0)                                   :: TFloat AS AmountIncome
                             , COALESCE (tmpReserve.Amount, 0)                                       :: TFloat AS AmountReserve
                             , COALESCE (CASE WHEN COALESCE(tmpData.Amount, 0) <> 0 THEN Object_Price.Price END, 0) :: TFloat AS PriceSale
                             , (tmpData.Amount * COALESCE (Object_Price.Price, 0))                   :: TFloat AS SummaSale
                             , Object_Price.DateChange                                                         AS DateChange 
                             , tmpData.MinExpirationDate  ::TDateTime
                             , ROUND (MinPrice_List.Price * (1.0 + COALESCE (tmpGoodsParams.NDS, 0) / 100.0), 2) :: TFloat  AS Price_min_NDS
                             , zfCalc_SalePrice((MinPrice_List.Price * (100 + tmpGoodsParams.NDS)/100),                         -- ���� � ���
                                             CASE WHEN COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0
                                                      THEN MarginCondition.MarginPercent + COALESCE (ObjectFloat_Contract_Percent.valuedata, 0)
                                                  ELSE MarginCondition.MarginPercent + COALESCE (ObjectFloat_Juridical_Percent.valuedata, 0)
                                             END,                                                                             -- % ������� � ���������
                                             COALESCE (NULLIF (Object_Price.isTOP, FALSE), Object_Goods_Retail.isTOP),           -- ��� �������
                                             COALESCE (NULLIF (Object_Price.PercentMarkup, 0), Object_Goods_Retail.PercentMarkup),  -- % ������� � ������
                                             0.0, --ObjectFloat_Juridical_Percent.valuedata,                                  -- % ������������� � �� ���� ��� ����
                                             Object_Goods_Retail.Price                                                        -- ���� � ������ (�������������)
                                           )         :: TFloat AS Price_min
                             , tmpIncome_1303.PriceSale AS PriceSaleIncome
                             , tmpGoods.IntenalSPId
                             , tmpGoods.IntenalSPName
                             , tmpGoods.BrandSPId
                             , tmpGoods.BrandSPName
                             , tmpGoods1303.isOrder408

                        FROM tmpGoods 
                            LEFT JOIN tmpUnit AS Object_Unit ON 1=1
                            LEFT JOIN tmpData ON tmpData.GoodsId = tmpGoods.Id
                                             AND tmpData.UnitId  = Object_Unit.UnitId
                                             
                            LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = tmpGoods.Id
                                             
                            LEFT JOIN tmpGoods1303 ON tmpGoods1303.GoodsId = tmpGoods.Id

                            LEFT JOIN tmpIncome ON tmpIncome.GoodsId = tmpGoods.Id
                                               AND tmpIncome.UnitId  = Object_Unit.UnitId

                            LEFT JOIN tmpReserve ON tmpReserve.GoodsId = tmpGoods.Id
                                                AND tmpReserve.UnitId  = Object_Unit.UnitId

                            LEFT JOIN tmpGoodsParams ON tmpGoodsParams.GoodsId = tmpGoods.Id

                            LEFT OUTER JOIN tmpPrice_View AS Object_Price
                                                          ON Object_Price.GoodsId = tmpGoods.Id
                                                         AND Object_Price.UnitId  = Object_Unit.UnitId


                            LEFT JOIN tmpMinPrice_List AS MinPrice_List ON MinPrice_List.GoodsId = tmpGoods.Id
                                                                       AND MinPrice_List.AreaId  = CASE WHEN Object_Unit.AreaId <> 12487449  THEN Object_Unit.AreaId ELSE zc_Area_Basis() END

                            LEFT JOIN tmpIncome_1303 ON tmpIncome_1303.GoodsId = tmpGoods.Id
                                                    AND tmpIncome_1303.UnitId = Object_Unit.UnitId

                            LEFT JOIN ObjectFloat AS ObjectFloat_Juridical_Percent
                                                  ON ObjectFloat_Juridical_Percent.ObjectId = MinPrice_List.JuridicalId
                                                 AND ObjectFloat_Juridical_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

                            LEFT JOIN ObjectFloat AS ObjectFloat_Contract_Percent
                                                  ON ObjectFloat_Contract_Percent.ObjectId = MinPrice_List.ContractId
                                                 AND ObjectFloat_Contract_Percent.DescId = zc_ObjectFloat_Contract_Percent()

                            LEFT JOIN tmpObject_MarginCategoryLink AS Object_MarginCategoryLink
                                                                     ON Object_MarginCategoryLink.UnitId = Object_Unit.UnitId
                                                                    AND Object_MarginCategoryLink.JuridicalId = MinPrice_List.JuridicalId
                                                                    AND Object_MarginCategoryLink.isErased    = FALSE

                            LEFT JOIN tmpObject_MarginCategoryLink AS Object_MarginCategoryLink_all
                                                                     ON COALESCE (Object_MarginCategoryLink_all.UnitId, 0) = 0
                                                                    AND Object_MarginCategoryLink_all.JuridicalId = MinPrice_List.JuridicalId
                                                                    AND Object_MarginCategoryLink_all.isErased    = FALSE
                                                                    AND Object_MarginCategoryLink.JuridicalId IS NULL

                            LEFT JOIN MarginCondition ON MarginCondition.MarginCategoryId = COALESCE (Object_MarginCategoryLink.MarginCategoryId, Object_MarginCategoryLink_all.MarginCategoryId)
                                                    AND (MinPrice_List.Price * (100 + tmpGoodsParams.NDS)/100)::TFloat BETWEEN MarginCondition.MinPrice AND MarginCondition.MaxPrice

                       )

        --���������
        SELECT tmpResult.GoodsId
             , tmpResult.GoodsCode
             , tmpResult.GoodsName
             , tmpResult.NDSkindName
             , tmpResult.NDS
             , tmpResult.GoodsGroupName
             , tmpResult.UnitId
             , tmpResult.UnitName
             , tmpResult.PartnerMedicalName
             , tmpResult.Address_Unit
             , tmpResult.Phone_Unit
             , tmpResult.ProvinceCityName_Unit
             , tmpResult.JuridicalName_Unit
             , tmpResult.PriceOptSP_1303
             , tmpResult.PriceSale_1303
             , tmpResult.Amount
             , tmpResult.AmountIncome
             , tmpResult.AmountReserve
             , tmpResult.PriceSale
             , tmpResult.SummaSale
             , tmpResult.DateChange 
             , tmpResult.MinExpirationDate
             , tmpResult.Price_min_NDS
             , tmpResult.Price_min
             , tmpResult.PriceSaleIncome
             , tmpResult.IntenalSPId
             , tmpResult.IntenalSPName
             , tmpResult.BrandSPId
             , tmpResult.BrandSPName
             , tmpResult.isOrder408
             , CASE WHEN tmpResult.PriceSale_1303 <
                         CASE WHEN COALESCE(tmpResult.Amount, 0) <> 0 
                              THEN CASE WHEN tmpResult.PriceSale < COALESCE (tmpResult.PriceSaleIncome, tmpResult.Price_min)
                                        THEN tmpResult.PriceSale
                                        ELSE COALESCE (tmpResult.PriceSaleIncome, tmpResult.Price_min) END
                              ELSE COALESCE (tmpResult.PriceSaleIncome, tmpResult.Price_min) END AND
                         (CASE WHEN COALESCE(tmpResult.Amount, 0) <> 0 
                               THEN CASE WHEN tmpResult.PriceSale < COALESCE (tmpResult.PriceSaleIncome, tmpResult.Price_min)
                                         THEN tmpResult.PriceSale
                                         ELSE COALESCE (tmpResult.PriceSaleIncome, tmpResult.Price_min) END
                               ELSE COALESCE (tmpResult.PriceSaleIncome, tmpResult.Price_min) END / tmpResult.PriceSale_1303 * 100 - 100) > vbDeviationsPrice1303
                    THEN zfCalc_Color (255, 165, 0) 
                    ELSE zc_Color_White() END      AS Color_calc
             , CASE WHEN tmpResult.PriceSale_1303 < tmpResult.Price_min AND tmpResult.Price_min > 0
                     AND (tmpResult.Price_min / tmpResult.PriceSale_1303 * 100 - 100) > vbDeviationsPrice1303
                    THEN zfCalc_Color (255, 165, 0) 
                    ELSE zc_Color_White() END      AS ColorMinPrice_calc
                    
        FROM tmpResult 
                                                       
        ORDER BY tmpResult.UnitName
               , tmpResult.GoodsGroupName
               , tmpResult.GoodsName
        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.07.22                                                       *
*/

-- ����
-- select * from gpSelect_GoodsSearchRemains_1303(inCodeSearch := '' , inGoodsSearch := '�����' , inPartnerMedicalID := 0 /*4474307*/ ,  inSession := '3');

-- select * from gpSelect_GoodsSearchRemains_1303(inCodeSearch := '' , inGoodsSearch := '�������� �����' , inPartnerMedicalID := 0 ,  inSession := '3');


select * from gpSelect_GoodsSearchRemains_1303(inCodeSearch := '' , inGoodsSearch := '����' , inPartnerMedicalID := 0 ,  inSession := '3');
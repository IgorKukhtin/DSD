 -- Function: gpSelect_GoodsOnUnit_ForSite()
DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnit_ForSite (Text, Text, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnit_ForSite(
    IN inUnitId_list      Text     ,  -- ������ �������������, ����� ���
    IN inGoodsId_list     Text     ,  -- ������ �������, ����� ���
    IN inFrontSite        Boolean  ,  -- �������� ����� �����
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (Id                Integer

             , deleted           Integer

             , UnitId            Integer   -- ������ (������������)
             , Remains           TFloat    -- ������� (� ������ �������)

             , Price_unit        TFloat -- ���� ������ ������
             , Price_unit_sale   TFloat -- ���� ������ �� �������
             , Price_min         TFloat -- ���� ����� ���������� � ��� � ��������
             , Price_min_sale    TFloat -- ���� ����� ���������� � ��� � �������� �� �������
             , Price_minD        TFloat -- Delivery - ���� ����� � ��� � �������� - ��������
             , Price_Discount    TFloat -- ���� �� ���������� ���������

             , JuridicalId       Integer    -- ��������� (�� �������� ������� ����� ����)
             , JuridicalName     TVarChar   -- ��������� (�� �������� ������� ����� ����)
             , ContractId        Integer    -- ������� (�� �������� ������� ����� ����)
             , ContractName      TVarChar   -- ������� (�� �������� ������� ����� ����)
             , ExpirationDate    TDateTime  -- ���� �������� (�� �������� ������� ����� ����)

             , PartionDateKindId_1  Integer  -- Id ����� - ������ 0 ��. � <=50 ��.
             , Remains_1            TFloat   -- ������� (� ������ �������)
             , Price_unit_1         TFloat   -- ���� ������ ������
             , Price_unit_sale_1    TFloat   -- ���� ������ �� �������

             , PartionDateKindId_3  Integer -- Id ����� - ������ 50 ��. � <=90 ��.
             , Remains_3            TFloat  -- ������� (� ������ �������) 
             , Price_unit_3         TFloat  -- ���� ������ ������
             , Price_unit_sale_3    TFloat  -- ���� ������ �� �������

             , PartionDateKindId_6  Integer   -- Id ����� - ������ 90 ��. � <=200 ��.
             , Remains_6            TFloat    -- ������� (� ������ �������)
             , Price_unit_6         TFloat    -- ���� ������ ������
             , Price_unit_sale_6    TFloat    -- ���� ������ �� �������
             
             , Multiplicity      TFloat    -- ����������� ��������� ��� �������
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;

   -- DECLARE inUnitId Integer;

   DECLARE vbIndex Integer;
   -- DECLARE vbMarginCategoryId Integer;
   DECLARE vbMarginCategoryId_site Integer;

/*   DECLARE vbOperDate_Begin1 TDateTime;
   DECLARE vbOperDate_Begin2 TDateTime;
   DECLARE vbOperDate_Begin3 TDateTime;
   DECLARE vbOperDate_Begin4 TDateTime;*/   
   DECLARE vbSiteDiscount TFloat;
   DECLARE vbQueryText Text;

   DECLARE vbDate_6 TDateTime;
   DECLARE vbDate_3 TDateTime;
   DECLARE vbDate_1 TDateTime;
   DECLARE vbDate_0 TDateTime;

   DECLARE vbPriceSamples TFloat;
   DECLARE vbSamples21 TFloat;
   DECLARE vbSamples22 TFloat;
   DECLARE vbSamples3 TFloat;
   DECLARE vbCat_5 TFloat;
   
BEGIN
     -- ����� ��������� ����� ������ ���������� ����.
     --vbOperDate_Begin1:= CLOCK_TIMESTAMP();

--raise notice 'Value 1: %', CLOCK_TIMESTAMP();

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

    -- ������������ <�������� ����>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', ABS (vbUserId));
    vbSiteDiscount := COALESCE (gpGet_GlobalConst_SiteDiscount(inSession), 0);

    -- �������� ��� ���������� �� ������
    SELECT Date_6, Date_3, Date_1, Date_0
    INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
    FROM lpSelect_PartionDateKind_SetDate ();

    SELECT COALESCE(ObjectFloat_CashSettings_PriceSamples.ValueData, 0)                          AS PriceSamples
         , COALESCE(ObjectFloat_CashSettings_Samples21.ValueData, 0)                             AS Samples21
         , COALESCE(ObjectFloat_CashSettings_Samples22.ValueData, 0)                             AS Samples22
         , COALESCE(ObjectFloat_CashSettings_Samples3.ValueData, 0)                              AS Samples3
         , COALESCE(ObjectFloat_CashSettings_Cat_5.ValueData, 0)                                 AS Cat_5
    INTO vbPriceSamples, vbSamples21, vbSamples22, vbSamples3, vbCat_5
    FROM Object AS Object_CashSettings

         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_PriceSamples
                               ON ObjectFloat_CashSettings_PriceSamples.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_PriceSamples.DescId = zc_ObjectFloat_CashSettings_PriceSamples()
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_Samples21
                               ON ObjectFloat_CashSettings_Samples21.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_Samples21.DescId = zc_ObjectFloat_CashSettings_Samples21()
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_Samples22
                               ON ObjectFloat_CashSettings_Samples22.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_Samples22.DescId = zc_ObjectFloat_CashSettings_Samples22()
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_Samples3
                               ON ObjectFloat_CashSettings_Samples3.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_Samples3.DescId = zc_ObjectFloat_CashSettings_Samples3()
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_Cat_5
                               ON ObjectFloat_CashSettings_Cat_5.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_Cat_5.DescId = zc_ObjectFloat_CashSettings_Cat_5()

    WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
    LIMIT 1;    

    -- �������
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpGoodsMinPrice_List')
    THEN
        CREATE TEMP TABLE _tmpGoodsMinPrice_List (GoodsId Integer, GoodsId_retail Integer, GoodsGroupId Integer, Multiplicity TFloat, isExpDateExcSite boolean, isPublished boolean) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpGoodsMinPrice_List;
    END IF;
    -- �������
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpUnitMinPrice_List')
    THEN
        CREATE TEMP TABLE _tmpUnitMinPrice_List (UnitId Integer, AreaId Integer) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpUnitMinPrice_List;
    END IF;

    -- ������ �������������
    vbIndex := 1;
    WHILE SPLIT_PART (inUnitId_list, ',', vbIndex) <> '' LOOP
        -- ��������� �� ��� �����
        INSERT INTO _tmpUnitMinPrice_List (UnitId, AreaId)
           SELECT tmp.UnitId
                , COALESCE (OL_Unit_Area.ChildObjectId, zc_Area_Basis()) AS AreaId
           FROM (SELECT SPLIT_PART (inUnitId_list, ',', vbIndex) :: Integer AS UnitId
                ) AS tmp
                LEFT JOIN ObjectLink AS OL_Unit_Area
                                     ON OL_Unit_Area.ObjectId = tmp.UnitId
                                    AND OL_Unit_Area.DescId   = zc_ObjectLink_Unit_Area()
          ;
        -- ������ ����������
        vbIndex := vbIndex + 1;
    END LOOP;
    
    ANALYSE _tmpUnitMinPrice_List;

    -- !!!��������!!!
    -- inUnitId:= (SELECT tmpList.UnitId FROM _tmpUnitMinPrice_List LIMIT 1);

    -- !!!��������!!!
    -- INSERT INTO _tmpUnitMinPrice_List (UnitId) SELECT 0 WHERE NOT EXISTS (SELECT 1 FROM _tmpUnitMinPrice_List);

--raise notice 'Value 1: %', CLOCK_TIMESTAMP();

    -- ������ ������
    IF COALESCE(inGoodsId_list, '') <> ''
    THEN
      vbQueryText := 'INSERT INTO _tmpGoodsMinPrice_List (GoodsId, GoodsId_retail, GoodsGroupId, Multiplicity, isExpDateExcSite, isPublished)
                      SELECT  Retail4.Id, Retail4.Id, RetailMain.GoodsGroupId, RetailMain.Multiplicity, RetailMain.isExpDateExcSite, RetailMain.isPublished
                      FROM Object_Goods_Retail AS Retail4
                           --INNER JOIN Object_Goods_Retail AS RetailAll ON RetailAll.GoodsMainId  = Retail4.GoodsMainId
                           INNER JOIN Object_Goods_Main AS RetailMain ON RetailMain.Id  = Retail4.GoodsMainId
                      WHERE Retail4.Id IN ('||inGoodsId_list||')';

      EXECUTE vbQueryText;
    END IF;

    -- !!!�����������!!!
    ANALYZE _tmpUnitMinPrice_List;

--raise notice 'Value 2: %', CLOCK_TIMESTAMP();

    -- ���� ��� �������
    IF NOT EXISTS (SELECT 1 FROM _tmpGoodsMinPrice_List WHERE GoodsId <> 0)
    THEN
         -- ��� �������
         INSERT INTO _tmpGoodsMinPrice_List (GoodsId, GoodsId_retail, GoodsGroupId, Multiplicity, isExpDateExcSite, isPublished)
           -- SELECT DISTINCT Container.ObjectId -- ����� ����� "����"
           -- !!!�������� �����������, ����� ������ ����� �������!!!!
           SELECT DISTINCT
                  ObjectLink_Child_NB.ChildObjectId AS ObjectID -- ����� ����� "����"
                , Container.ObjectId
                , ObjectLink_Goods_GoodsGroup.ChildObjectId
                , ObjectFloat_Goods_Multiplicity.ValueData
                , COALESCE (ObjectBoolean_Goods_ExpDateExcSite.ValueData, False) 
                , COALESCE (ObjectBoolean_Goods_Published.ValueData, False) 
           FROM _tmpUnitMinPrice_List
                INNER JOIN Container ON Container.WhereObjectId = _tmpUnitMinPrice_List.UnitId
                                    AND Container.DescId = zc_Container_Count()
                                    AND Container.Amount <> 0
                -- !!!�������� �����������, ����� ������ ����� �������!!!!
                INNER JOIN ObjectLink AS ObjectLink_Child
                                      ON ObjectLink_Child.ChildObjectId = Container.ObjectId
                                     AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                         AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                INNER JOIN ObjectLink AS ObjectLink_Main_NB ON ObjectLink_Main_NB.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                           AND ObjectLink_Main_NB.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                INNER JOIN ObjectLink AS ObjectLink_Child_NB ON ObjectLink_Child_NB.ObjectId = ObjectLink_Main_NB.ObjectId
                                                            AND ObjectLink_Child_NB.DescId   = zc_ObjectLink_LinkGoods_Goods()
                INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                      ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_NB.ChildObjectId
                                     AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                     AND ObjectLink_Goods_Object.ChildObjectId = 4 -- !!!NeBoley!!!
                LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                     ON ObjectLink_Goods_GoodsGroup.ObjectId = Container.ObjectId
                                    AND ObjectLink_Goods_GoodsGroup.DescId        = zc_ObjectLink_Goods_GoodsGroup()
                LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Multiplicity
                                      ON ObjectFloat_Goods_Multiplicity.ObjectId = Container.ObjectId
                                     AND ObjectFloat_Goods_Multiplicity.DescId   = zc_ObjectFloat_Goods_Multiplicity()
                LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_ExpDateExcSite
                                        ON ObjectBoolean_Goods_ExpDateExcSite.ObjectId = ObjectLink_Main.ChildObjectId
                                       AND ObjectBoolean_Goods_ExpDateExcSite.DescId   = zc_ObjectBoolean_Goods_ExpDateExcSite()
                LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Published
                                        ON ObjectBoolean_Goods_Published.ObjectId = Container.ObjectId
                                       AND ObjectBoolean_Goods_Published.DescId = zc_ObjectBoolean_Goods_Published()
          ;
    END IF;

    -- !!!�����������!!!
    ANALYZE _tmpGoodsMinPrice_List;

--raise notice 'Value 3: %', CLOCK_TIMESTAMP();

    -- ��� ������������ - _tmpContainerCount
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpContainerCount'))
    THEN
        -- �������
        CREATE TEMP TABLE _tmpContainerCount (UnitId Integer, GoodsId Integer, GoodsId_retail Integer, Amount TFloat) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpContainerCount;
    END IF;
    --
    INSERT INTO _tmpContainerCount (UnitId, GoodsId, GoodsId_retail, Amount)
                WITH tmpContainer AS
               (SELECT Container.WhereObjectId                AS UnitId
                     , _tmpGoodsMinPrice_List.GoodsId         AS GoodsId
                     , _tmpGoodsMinPrice_List.GoodsId_retail  AS GoodsId_retail
                     , SUM (Container.Amount)                 AS Amount
                FROM _tmpGoodsMinPrice_List
                     INNER JOIN Container ON Container.ObjectId = _tmpGoodsMinPrice_List.GoodsId_retail
                                         AND Container.DescId   = zc_Container_Count()
                                         AND Container.Amount   <> 0
                                         AND Container.WhereObjectId IN (SELECT _tmpUnitMinPrice_List.UnitId FROM _tmpUnitMinPrice_List)
                WHERE _tmpGoodsMinPrice_List.isPublished = True
                GROUP BY Container.WhereObjectId
                       , _tmpGoodsMinPrice_List.GoodsId
                       , _tmpGoodsMinPrice_List.GoodsId_retail
                HAVING SUM (Container.Amount) > 0
               )
                -- ���������
                SELECT tmpContainer.UnitId
                     , tmpContainer.GoodsId
                     , tmpContainer.GoodsId_retail
                     , tmpContainer.Amount
                FROM tmpContainer
                     -- INNER JOIN _tmpUnitMinPrice_List ON _tmpUnitMinPrice_List.UnitId = tmpContainer.UnitId
               ;

    -- !!!�����������!!!
    ANALYZE _tmpContainerCount;

--raise notice 'Value 4: %', CLOCK_TIMESTAMP();

    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpMovementCheck'))
    THEN
        -- �������
        CREATE TEMP TABLE _tmpMovementCheck (Id Integer, UnitId Integer) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpMovementCheck;
    END IF;
    --
    INSERT INTO _tmpMovementCheck (Id, UnitId)
      WITH           -- ������� �� ������
            tmpMovementCheck AS (SELECT Movement.Id
                                 FROM Movement
                                 WHERE Movement.DescId = zc_Movement_Check()
                                   AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                   AND Movement.OperDate >= CURRENT_DATE - INTERVAL '1 MONTH')
          , tmpMovReserveId AS (
                             SELECT Movement.Id
                                  , COALESCE(MovementBoolean_Deferred.ValueData, FALSE) AS  isDeferred
                                  ,  MovementString_CommentError.ValueData <> ''        AS  isCommentError
                             FROM tmpMovementCheck AS Movement
                                  LEFT JOIN MovementBoolean AS MovementBoolean_Deferred ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                            AND MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                                  LEFT JOIN MovementString AS MovementString_CommentError ON Movement.Id     = MovementString_CommentError.MovementId
                                                          AND MovementString_CommentError.DescId = zc_MovementString_CommentError()
                                                          AND MovementString_CommentError.ValueData <> ''                             )

          , tmpMovReserveAll AS (
                             SELECT Movement.Id
                             FROM tmpMovReserveId AS Movement
                             WHERE isDeferred = TRUE OR isCommentError = TRUE)

    SELECT Movement.Id 
	     , MovementLinkObject_Unit.ObjectId    AS UnitId
	FROM tmpMovReserveAll AS Movement
		 INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
									   ON MovementLinkObject_Unit.movementid = Movement.Id
									  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
	;

    -- !!!�����������!!!
    ANALYZE _tmpMovementCheck;

--raise notice 'Value 5: %', CLOCK_TIMESTAMP();

    -- ��� ������������ - _tmpMinPrice_List
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('MovementItemChildId'))
    THEN
        -- �������
        CREATE TEMP TABLE MovementItemChildId (Id        Integer,
                                             Amount            TFloat
                                             ) ON COMMIT DROP;
    ELSE
        DELETE FROM MovementItemChildId;
    END IF;
	
    INSERT INTO MovementItemChildId
                SELECT MovementItemChild.Id
                     , MovementItemChild.Amount
                FROM MovementItem AS MovementItemChild
                WHERE MovementItemChild.MovementId IN (SELECT Movement.Id FROM _tmpMovementCheck AS Movement)
                  AND MovementItemChild.DescId     = zc_MI_Child()
                  AND MovementItemChild.Amount     > 0
                  AND MovementItemChild.isErased   = FALSE;
          
    ANALYZE MovementItemChildId;

--raise notice 'Value 5.1: %', CLOCK_TIMESTAMP();

    -- ��� ������������ - _tmpList
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpList'))
    THEN
        -- �������
        CREATE TEMP TABLE _tmpList (UnitId Integer, AreaId Integer, GoodsId Integer, GoodsId_retail Integer, Multiplicity TFloat) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpList;
    END IF;
    --
    INSERT INTO _tmpList (UnitId, AreaId, GoodsId, GoodsId_retail, Multiplicity)

                SELECT DISTINCT
                       _tmpUnitMinPrice_List.UnitId
                     , _tmpUnitMinPrice_List.AreaId
                     , _tmpGoodsMinPrice_List.GoodsId
                     , _tmpGoodsMinPrice_List.GoodsId_retail
                     , _tmpGoodsMinPrice_List.Multiplicity
                FROM _tmpGoodsMinPrice_List
                     CROSS JOIN _tmpUnitMinPrice_List -- ON 1=1
                     LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                          ON ObjectLink_Unit_Juridical.ObjectId = _tmpUnitMinPrice_List.UnitId
                                         AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                     LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                          ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                         AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                     INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                           ON ObjectLink_Goods_Object.ObjectId = _tmpGoodsMinPrice_List.GoodsId_retail
                                          AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                          AND ObjectLink_Goods_Object.ChildObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                ;
    INSERT INTO _tmpList (UnitId, AreaId, GoodsId, GoodsId_retail, Multiplicity)
                SELECT DISTINCT
                       _tmpUnitMinPrice_List.UnitId
                     , _tmpUnitMinPrice_List.AreaId
                     , _tmpGoodsMinPrice_List.GoodsId
                     , _tmpGoodsMinPrice_List.GoodsId AS GoodsId_retail
                     , _tmpGoodsMinPrice_List.Multiplicity
                FROM _tmpGoodsMinPrice_List
                     CROSS JOIN _tmpUnitMinPrice_List -- ON 1=1
                     LEFT JOIN _tmpList ON _tmpList.UnitId = _tmpUnitMinPrice_List.UnitId
                                       AND _tmpList.GoodsId = _tmpGoodsMinPrice_List.GoodsId
                WHERE _tmpList.GoodsId IS NULL;

    -- !!!�����������!!!
    ANALYZE _tmpList;

    -- ��� ������������ - _tmpMinPrice_List
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpMinPrice_List'))
    THEN
        -- �������
        CREATE TEMP TABLE _tmpMinPrice_List (GoodsId            Integer,
                                            GoodsCode          Integer,
                                            GoodsName          TVarChar,
                                            PartionGoodsDate   TDateTime,
                                            Partner_GoodsId    Integer,
                                            Partner_GoodsCode  TVarChar,
                                            Partner_GoodsName  TVarChar,
                                            MakerName          TVarChar,
                                            ContractId         Integer,
                                            AreaId             Integer,
                                            JuridicalId        Integer,
                                            JuridicalName      TVarChar,
                                            Price              TFloat,
                                            SuperFinalPrice    TFloat,
                                            isTop              Boolean,
                                            isOneJuridical     Boolean
                                           ) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpMinPrice_List;
    END IF;

    -- ��������� ����� ����� lpSelectMinPrice_List
    --vbOperDate_Begin2:= CLOCK_TIMESTAMP();

    --
    INSERT INTO _tmpMinPrice_List (GoodsId            ,
                                   GoodsCode          ,
                                   GoodsName          ,
                                   PartionGoodsDate   ,
                                   Partner_GoodsId    ,
                                   Partner_GoodsCode  ,
                                   Partner_GoodsName  ,
                                   MakerName          ,
                                   ContractId         ,
                                   AreaId             ,
                                   JuridicalId        ,
                                   JuridicalName      ,
                                   Price              ,
                                   SuperFinalPrice    ,
                                   isTop              ,
                                   isOneJuridical)

          WITH
            GoodsList_all AS
             (SELECT Distinct _tmpGoodsMinPrice_List.GoodsId  AS GoodsId
              FROM _tmpGoodsMinPrice_List
              WHERE _tmpGoodsMinPrice_List.isPublished = True)

          SELECT
              MinPriceList.GoodsId,
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
          FROM GoodsList_all
               INNER JOIN MinPrice_ForSite AS MinPriceList
                                           ON GoodsList_all.GoodsId = MinPriceList.GoodsId
          ;

    -- !!!�����������!!!
    ANALYZE _tmpMinPrice_List;

    -- ��������� ����� ����� lpSelectMinPrice_List
    --vbOperDate_Begin3:= CLOCK_TIMESTAMP();

    -- ����� ��������� ��� �����
    vbMarginCategoryId_site:= (SELECT ObjectBoolean.ObjectId
                               FROM ObjectBoolean
                               WHERE ObjectBoolean.ValueData = TRUE
                                 AND ObjectBoolean.DescId = zc_ObjectBoolean_MarginCategory_Site()
                               LIMIT 1
                              );

--raise notice 'Value 7: %', CLOCK_TIMESTAMP();

    -- ��� ������������ - _tmpMinPrice_List
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('Price_Unit_all'))
    THEN
        -- �������
        CREATE TEMP TABLE Price_Unit_all (UnitId            Integer,
                                          GoodsId           Integer,
										  Price             TFloat,
										  PriceSale         TFloat,
										  isTop             Boolean,
                                          PriceChange       TFloat,
                                          FixPrice          TFloat,
                                          FixPercent        TFloat,
                                          FixDiscount       TFloat,
										  PercentMarkup     TFloat,
                                          Multiplicity      TFloat
                                          ) ON COMMIT DROP;
    ELSE
        DELETE FROM Price_Unit_all;
    END IF;
	
    INSERT INTO Price_Unit_all
            -- ���� �� �������
       WITH tmpPriceChange AS (SELECT DISTINCT ObjectLink_PriceChange_Goods.ChildObjectId        AS GoodsId
                                    , PriceChange_Value_Retail.ValueData                         AS PriceChange
                                    , PriceChange_FixPercent_Retail.ValueData                    AS FixPercent
                                    , PriceChange_FixDiscount_Retail.ValueData                   AS FixDiscount
                                    , PriceChange_Multiplicity_Retail.ValueData                  AS Multiplicity
                               FROM Object AS Object_PriceChange
       
                                    -- ������ �� ����
                                    LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Retail
                                                         ON ObjectLink_PriceChange_Retail.ObjectId = Object_PriceChange.Id
                                                        AND ObjectLink_PriceChange_Retail.DescId = zc_ObjectLink_PriceChange_Retail()
                                                        AND ObjectLink_PriceChange_Retail.ChildObjectId = vbObjectId
                                    -- ���� �� ������� �� ����
                                    LEFT JOIN ObjectFloat AS PriceChange_Value_Retail
                                                          ON PriceChange_Value_Retail.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                         AND PriceChange_Value_Retail.DescId = zc_ObjectFloat_PriceChange_Value()
                                    -- ������� ������ �� ����.
                                    LEFT JOIN ObjectFloat AS PriceChange_FixPercent_Retail
                                                          ON PriceChange_FixPercent_Retail.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                         AND PriceChange_FixPercent_Retail.DescId = zc_ObjectFloat_PriceChange_FixPercent()
                                    -- ����� ������ �� ����.
                                    LEFT JOIN ObjectFloat AS PriceChange_FixDiscount_Retail
                                                          ON PriceChange_FixDiscount_Retail.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                         AND PriceChange_FixDiscount_Retail.DescId = zc_ObjectFloat_PriceChange_FixDiscount()
                                    -- ��������� ������� �� ����.
                                    LEFT JOIN ObjectFloat AS PriceChange_Multiplicity_Retail
                                                          ON PriceChange_Multiplicity_Retail.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                         AND PriceChange_Multiplicity_Retail.DescId = zc_ObjectFloat_PriceChange_Multiplicity()
                                    -- ���� ��������� �������� ������ �� ����.
                                    LEFT JOIN ObjectDate AS PriceChange_FixEndDate_Retail
                                                         ON PriceChange_FixEndDate_Retail.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                        AND PriceChange_FixEndDate_Retail.DescId = zc_ObjectDate_PriceChange_FixEndDate()

                                    LEFT JOIN ObjectLink AS ObjectLink_PriceChange_PartionDateKind_Retail
                                                          ON ObjectLink_PriceChange_PartionDateKind_Retail.ObjectId  = ObjectLink_PriceChange_Retail.ObjectId
                                                         AND ObjectLink_PriceChange_PartionDateKind_Retail.DescId    = zc_ObjectLink_PriceChange_PartionDateKind()

                                    LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Goods
                                                         ON ObjectLink_PriceChange_Goods.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                        AND ObjectLink_PriceChange_Goods.DescId = zc_ObjectLink_PriceChange_Goods()

                               WHERE Object_PriceChange.DescId = zc_Object_PriceChange()
                                 AND Object_PriceChange.isErased = FALSE
                                 AND (COALESCE (PriceChange_Value_Retail.ValueData, 0) <> 0 OR
                                     COALESCE (PriceChange_FixPercent_Retail.ValueData, 0) <> 0 OR
                                     COALESCE (PriceChange_FixDiscount_Retail.ValueData, 0) <> 0)
                                 AND COALESCE (PriceChange_Multiplicity_Retail.ValueData, 0) IN (0, 1)
                                 AND COALESCE (PriceChange_FixEndDate_Retail.ValueData, CURRENT_DATE) >= CURRENT_DATE   
                                 AND COALESCE (ObjectLink_PriceChange_PartionDateKind_Retail.ChildObjectId, 0) = 0 
                              )
          , tmpPriceChangeUnit AS (SELECT DISTINCT ObjectLink_PriceChange_Goods.ChildObjectId        AS GoodsId
                                        , ObjectLink_PriceChange_Unit.ChildObjectId                  AS UnitId
                                        , PriceChange_Value_Unit.ValueData                           AS PriceChange
                                        , PriceChange_FixPercent_Unit.ValueData                      AS FixPercent
                                        , PriceChange_FixDiscount_Unit.ValueData                     AS FixDiscount
                                        , PriceChange_Multiplicity_Unit.ValueData                    AS Multiplicity
                                   FROM Object AS Object_PriceChange
                                        -- ������ �� �������
                                        LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Unit
                                                             ON ObjectLink_PriceChange_Unit.ObjectId = Object_PriceChange.Id
                                                            AND ObjectLink_PriceChange_Unit.DescId = zc_ObjectLink_PriceChange_Unit()
                                                            AND ObjectLink_PriceChange_Unit.ChildObjectId <> 0
                                        -- ���� �� ������� �� �������.
                                        LEFT JOIN ObjectFloat AS PriceChange_Value_Unit
                                                              ON PriceChange_Value_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                             AND PriceChange_Value_Unit.DescId = zc_ObjectFloat_PriceChange_Value()
                                                             AND COALESCE (PriceChange_Value_Unit.ValueData, 0) <> 0
                                        -- ������� ������ �� �������.
                                        LEFT JOIN ObjectFloat AS PriceChange_FixPercent_Unit
                                                              ON PriceChange_FixPercent_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                             AND PriceChange_FixPercent_Unit.DescId = zc_ObjectFloat_PriceChange_FixPercent()
                                                             AND COALESCE (PriceChange_FixPercent_Unit.ValueData, 0) <> 0
                                        -- ����� ������ �� �������.
                                        LEFT JOIN ObjectFloat AS PriceChange_FixDiscount_Unit
                                                              ON PriceChange_FixDiscount_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                             AND PriceChange_FixDiscount_Unit.DescId = zc_ObjectFloat_PriceChange_FixDiscount()
                                                             AND COALESCE (PriceChange_FixDiscount_Unit.ValueData, 0) <> 0
                                        -- ��������� �������
                                        LEFT JOIN ObjectFloat AS PriceChange_Multiplicity_Unit
                                                              ON PriceChange_Multiplicity_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                             AND PriceChange_Multiplicity_Unit.DescId = zc_ObjectFloat_PriceChange_Multiplicity()
                                                             AND COALESCE (PriceChange_Multiplicity_Unit.ValueData, 0) <> 0
                                        -- ���� ��������� �������� ������
                                        LEFT JOIN ObjectDate AS PriceChange_FixEndDate_Unit
                                                             ON PriceChange_FixEndDate_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                            AND PriceChange_FixEndDate_Unit.DescId = zc_ObjectDate_PriceChange_FixEndDate()
                                                                
                                        LEFT JOIN ObjectLink AS ObjectLink_PriceChange_PartionDateKind_Unit
                                                             ON ObjectLink_PriceChange_PartionDateKind_Unit.ObjectId  = ObjectLink_PriceChange_Unit.ObjectId
                                                            AND ObjectLink_PriceChange_PartionDateKind_Unit.DescId    = zc_ObjectLink_PriceChange_PartionDateKind()

                                        LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Goods
                                                             ON ObjectLink_PriceChange_Goods.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                            AND ObjectLink_PriceChange_Goods.DescId = zc_ObjectLink_PriceChange_Goods()
                                                                
                                   WHERE Object_PriceChange.DescId = zc_Object_PriceChange()
                                     AND Object_PriceChange.isErased = FALSE
                                     AND (COALESCE (PriceChange_Value_Unit.ValueData, 0) <> 0 OR
                                         COALESCE (PriceChange_FixPercent_Unit.ValueData, 0) <> 0 OR
                                         COALESCE (PriceChange_FixDiscount_Unit.ValueData, 0) <> 0)
                                     AND COALESCE (PriceChange_Multiplicity_Unit.ValueData, 0) IN (0, 1)
                                     AND COALESCE (PriceChange_FixEndDate_Unit.ValueData, CURRENT_DATE) >= CURRENT_DATE   
                                     AND COALESCE (ObjectLink_PriceChange_PartionDateKind_Unit.ChildObjectId, 0) = 0 
                                  )
                                  
                SELECT _tmpList.UnitId
                     , _tmpList.GoodsId
                     , CASE WHEN PriceSite_DiscontStart.ValueData IS NOT NULL
                             AND PriceSite_DiscontEnd.ValueData IS NOT NULL  
                             AND PriceSite_DiscontStart.ValueData <= CURRENT_DATE
                             AND PriceSite_DiscontEnd.ValueData >= CURRENT_DATE
                             AND COALESCE (PriceSite_DiscontAmount.ValueData, 0) > 0
                            THEN ROUND(CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                             AND ObjectFloat_Goods_Price.ValueData > 0
                                                 THEN ObjectFloat_Goods_Price.ValueData
                                            ELSE ObjectFloat_Price_Value.ValueData
                                       END - COALESCE (PriceSite_DiscontAmount.ValueData, 0), 2)
                            WHEN PriceSite_DiscontStart.ValueData IS NOT NULL
                             AND PriceSite_DiscontEnd.ValueData IS NOT NULL  
                             AND PriceSite_DiscontStart.ValueData <= CURRENT_DATE
                             AND PriceSite_DiscontEnd.ValueData >= CURRENT_DATE
                             AND COALESCE (PriceSite_DiscontPercent.ValueData, 0) > 0 
                            THEN ROUND(CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                             AND ObjectFloat_Goods_Price.ValueData > 0
                                                 THEN ObjectFloat_Goods_Price.ValueData
                                            ELSE ObjectFloat_Price_Value.ValueData
                                       END * (100 - COALESCE (PriceSite_DiscontPercent.ValueData, 0)) / 100, 1)
                            ELSE CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                       AND ObjectFloat_Goods_Price.ValueData > 0
                                           THEN ObjectFloat_Goods_Price.ValueData
                                      ELSE ObjectFloat_Price_Value.ValueData
                                 END 
                            END::TFloat       AS Price
                     , CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                             AND ObjectFloat_Goods_Price.ValueData > 0
                                 THEN ObjectFloat_Goods_Price.ValueData
                            ELSE ObjectFloat_Price_Value.ValueData
                       END::TFloat                                           AS PriceSale
                     , COALESCE (NULLIF (ObjectBoolean_Goods_TOP.ValueData, FALSE), COALESCE (ObjectBoolean_Goods_TOP.ValueData, FALSE))         AS isTop

                     , CASE WHEN COALESCE (tmpPriceChangeUnit.PriceChange, tmpPriceChange.PriceChange, 0) > 0 
                            THEN COALESCE (tmpPriceChangeUnit.PriceChange, tmpPriceChange.PriceChange, 0)
                            WHEN COALESCE (tmpPriceChangeUnit.FixPercent, tmpPriceChange.FixPercent, 0) > 0 
                            THEN CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                       AND ObjectFloat_Goods_Price.ValueData > 0
                                           THEN ObjectFloat_Goods_Price.ValueData
                                      ELSE ObjectFloat_Price_Value.ValueData
                                 END  * (100.0 - COALESCE (tmpPriceChangeUnit.FixPercent, tmpPriceChange.FixPercent, 0)) / 100.0
                            WHEN COALESCE (tmpPriceChangeUnit.FixDiscount, tmpPriceChange.FixDiscount, 0) > 0 AND 
                                 CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                       AND ObjectFloat_Goods_Price.ValueData > 0
                                           THEN ObjectFloat_Goods_Price.ValueData
                                      ELSE ObjectFloat_Price_Value.ValueData
                                 END  > COALESCE (tmpPriceChangeUnit.FixDiscount, tmpPriceChange.FixDiscount, 0)
                            THEN CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                       AND ObjectFloat_Goods_Price.ValueData > 0
                                           THEN ObjectFloat_Goods_Price.ValueData
                                      ELSE ObjectFloat_Price_Value.ValueData
                                 END  - COALESCE (tmpPriceChangeUnit.FixDiscount, tmpPriceChange.FixDiscount, 0)
                            ELSE Null END                                                         AS PriceChange
                     , COALESCE (tmpPriceChangeUnit.PriceChange, tmpPriceChange.PriceChange, 0)   AS FixPrice
                     , COALESCE (tmpPriceChangeUnit.FixPercent, tmpPriceChange.FixPercent, 0)     AS FixPercent
                     , COALESCE (tmpPriceChangeUnit.FixDiscount, tmpPriceChange.FixDiscount, 0)   AS FixDiscount
                     , COALESCE (NULLIF (ObjectFloat_PercentMarkup.ValueData, 0), COALESCE (ObjectFloat_Goods_PercentMarkup.ValueData, 0)) AS PercentMarkup
                     , COALESCE (tmpPriceChangeUnit.Multiplicity, tmpPriceChange.Multiplicity, 0) AS Multiplicity


                FROM _tmpList

                     INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                           ON ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                          AND ObjectLink_Price_Unit.ChildObjectId = _tmpList.UnitId
                     INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                           ON ObjectLink_Price_Goods.ChildObjectId = _tmpList.GoodsId_retail -- _tmpGoodsMinPrice_List.GoodsId
                                          AND ObjectLink_Price_Unit.ObjectId      = ObjectLink_Price_Goods.ObjectId 
                                          AND ObjectLink_Price_Goods.DescId        = zc_ObjectLink_Price_Goods()
                     LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                           ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Price_Goods.ObjectId
                                          AND ObjectFloat_Price_Value.DescId = zc_ObjectFloat_Price_Value()
                     LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                             ON ObjectBoolean_Top.ObjectId = ObjectLink_Price_Goods.ObjectId
                                            AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_Price_Top()
                     LEFT JOIN ObjectFloat AS ObjectFloat_PercentMarkup
                                           ON ObjectFloat_PercentMarkup.ObjectId = ObjectLink_Price_Unit.ObjectId
                                          AND ObjectFloat_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
                     -- ���� ���� ��� ���� ����
                     LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                            ON ObjectFloat_Goods_Price.ObjectId = ObjectLink_Price_Goods.ChildObjectId
                                           AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                     LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                             ON ObjectBoolean_Goods_TOP.ObjectId = _tmpList.GoodsId_retail
                                            AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                     LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PercentMarkup
                                           ON ObjectFloat_Goods_PercentMarkup.ObjectId = _tmpList.GoodsId_retail
                                          AND ObjectFloat_Goods_PercentMarkup.DescId = zc_ObjectFloat_Goods_PercentMarkup()
                     LEFT JOIN ObjectDate AS PriceSite_DiscontStart
                                          ON PriceSite_DiscontStart.ObjectId = _tmpList.GoodsId_retail
                                         AND PriceSite_DiscontStart.DescId = zc_ObjectDate_Goods_DiscontSiteStart()
                     LEFT JOIN ObjectDate AS PriceSite_DiscontEnd
                                          ON PriceSite_DiscontEnd.ObjectId = _tmpList.GoodsId_retail
                                         AND PriceSite_DiscontEnd.DescId = zc_ObjectDate_Goods_DiscontSiteEnd()
                     LEFT JOIN ObjectFloat AS PriceSite_DiscontAmount
                                           ON PriceSite_DiscontAmount.ObjectId = _tmpList.GoodsId_retail
                                          AND PriceSite_DiscontAmount.DescId = zc_ObjectFloat_Goods_DiscontAmountSite()
                     LEFT JOIN ObjectFloat AS PriceSite_DiscontPercent
                                           ON PriceSite_DiscontPercent.ObjectId = _tmpList.GoodsId_retail
                                          AND PriceSite_DiscontPercent.DescId = zc_ObjectFloat_Goods_DiscontPercentSite()
                     LEFT JOIN tmpPriceChangeUnit ON tmpPriceChangeUnit.GoodsId = _tmpList.GoodsId
                                                 AND tmpPriceChangeUnit.UnitId = _tmpList.UnitId
                     LEFT JOIN tmpPriceChange ON tmpPriceChange.GoodsId = _tmpList.GoodsId
                                             AND COALESCE (tmpPriceChangeUnit.GoodsId, 0) = 0
                     ;

    -- !!!�����������!!!
    ANALYZE Price_Unit_all;

--raise notice 'Value 8: %', CLOCK_TIMESTAMP();

    -- ��� ������������ - _tmpMinPrice_List
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpMI_DeferredAll'))
    THEN
        -- �������
        CREATE TEMP TABLE tmpMI_DeferredAll (MovementId        Integer,
                                             GoodsId           Integer,
                                             Amount            TFloat
                                             ) ON COMMIT DROP;
    ELSE
        DELETE FROM tmpMI_DeferredAll;
    END IF;
	
    INSERT INTO tmpMI_DeferredAll
                SELECT MovementItem.MovementId
                     , MovementItem.ObjectId              AS GoodsId
                     , MovementItem.Amount               AS Amount
                FROM _tmpMovementCheck AS Movement
                
                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = FALSE;
          
    ANALYZE tmpMI_DeferredAll;

--raise notice 'Value 9: % %', CLOCK_TIMESTAMP(), (SELECT COUNT(*) FROM tmpMI_DeferredAll AS Movement);

    -- ��� ������������ - tmpGoodsDiscount
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpGoodsDiscount'))
    THEN
        -- �������
        CREATE TEMP TABLE tmpGoodsDiscount (UnitId Integer, GoodsId Integer, DiscountExternalId Integer, isDiscountSite Boolean, MaxPrice TFloat, DiscountProcent TFloat) ON COMMIT DROP;
    ELSE
        DELETE FROM tmpGoodsDiscount;
    END IF;
    --    
          -- ������ ���������� ���������
       WITH tmpUnitDiscount AS (SELECT ObjectLink_DiscountExternal.ChildObjectId     AS DiscountExternalId
                                     , ObjectLink_Unit.ChildObjectId                  AS UnitId
                                FROM Object AS Object_DiscountExternalTools
                                      LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                                           ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalTools.Id
                                                          AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalTools_DiscountExternal()
                                      LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                           ON ObjectLink_Unit.ObjectId = Object_DiscountExternalTools.Id
                                                          AND ObjectLink_Unit.DescId = zc_ObjectLink_DiscountExternalTools_Unit()
                                 WHERE Object_DiscountExternalTools.DescId = zc_Object_DiscountExternalTools()
                                   AND Object_DiscountExternalTools.isErased = False
                                 )
          -- ������ ���������� ���������
    INSERT INTO tmpGoodsDiscount 
     SELECT tmpUnitDiscount.UnitId                                 AS UnitId
          , ObjectLink_BarCode_Goods.ChildObjectId                 AS GoodsId
          , tmpUnitDiscount.DiscountExternalId                     AS DiscountExternalId
          , COALESCE (ObjectBoolean_DiscountSite.ValueData, False) AS isDiscountSite
                                                   
          , MAX(ObjectFloat_MaxPrice.ValueData)                    AS MaxPrice 
          , MAX(ObjectFloat_DiscountProcent.ValueData)             AS DiscountProcent 
                                                                               
      FROM Object AS Object_BarCode

           LEFT JOIN ObjectBoolean AS ObjectBoolean_DiscountSite
                                    ON ObjectBoolean_DiscountSite.ObjectId = Object_BarCode.Id
                                   AND ObjectBoolean_DiscountSite.DescId = zc_ObjectBoolean_BarCode_DiscountSite()
                                   AND ObjectBoolean_DiscountSite.ValueData = True

           LEFT JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                               AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                           
           LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                               AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
           LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId           

           LEFT JOIN tmpUnitDiscount ON tmpUnitDiscount.DiscountExternalId = ObjectLink_BarCode_Object.ChildObjectId 

           LEFT JOIN ObjectFloat AS ObjectFloat_MaxPrice
                                 ON ObjectFloat_MaxPrice.ObjectId = Object_BarCode.Id
                                AND ObjectFloat_MaxPrice.DescId = zc_ObjectFloat_BarCode_MaxPrice()
           LEFT JOIN ObjectFloat AS ObjectFloat_DiscountProcent
                                 ON ObjectFloat_DiscountProcent.ObjectId = Object_BarCode.Id
                                AND ObjectFloat_DiscountProcent.DescId = zc_ObjectFloat_BarCode_DiscountProcent()

     WHERE Object_BarCode.DescId = zc_Object_BarCode()
       AND Object_BarCode.isErased = False
       AND Object_Object.isErased = False
       AND COALESCE (tmpUnitDiscount.DiscountExternalId, 0) <> 0
       AND ObjectLink_BarCode_Goods.ChildObjectId in (SELECT DISTINCT _tmpGoodsMinPrice_List.GoodsId FROM _tmpGoodsMinPrice_List)
     GROUP BY tmpUnitDiscount.UnitId
            , ObjectLink_BarCode_Goods.ChildObjectId
            , ObjectBoolean_DiscountSite.ValueData
            , tmpUnitDiscount.DiscountExternalId 
    ;
    
    ANALYSE tmpGoodsDiscount;
    
    -- ��� ������������ - tmpGoodsSP_FS
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpGoodsSP_FS'))
    THEN
        -- �������
        CREATE TEMP TABLE tmpGoodsSP_FS (GoodsId Integer, isElectronicPrescript Boolean, PriceSP TFloat, Ord Integer) ON COMMIT DROP;
    ELSE
        DELETE FROM tmpGoodsSP_FS;
    END IF;
    --    
    INSERT INTO tmpGoodsSP_FS 
     SELECT Object_Goods_Retail.Id      AS GoodsId
          , COALESCE (ObjectBoolean_ElectronicPrescript.ValueData, False) AS isElectronicPrescript
          , MIFloat_PriceSP.ValueData     AS PriceSP
                                          -- � �/� - �� ������ ������
          , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC) AS Ord
     FROM Movement
          INNER JOIN MovementDate AS MovementDate_OperDateStart
                                  ON MovementDate_OperDateStart.MovementId = Movement.Id
                                 AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                 AND MovementDate_OperDateStart.ValueData  <= CURRENT_DATE
 
          INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                  ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                 AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                 AND MovementDate_OperDateEnd.ValueData  >= CURRENT_DATE
          INNER JOIN MovementLinkObject AS MLO_MedicalProgramSP
                                        ON MLO_MedicalProgramSP.MovementId = Movement.Id
                                       AND MLO_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
 
          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = FALSE
 
          LEFT JOIN ObjectBoolean AS ObjectBoolean_ElectronicPrescript
                                  ON ObjectBoolean_ElectronicPrescript.ObjectId = COALESCE (MLO_MedicalProgramSP.ObjectId, 18076882)
                                 AND ObjectBoolean_ElectronicPrescript.DescId = zc_ObjectBoolean_MedicalProgramSP_ElectronicPrescript()

          INNER JOIN MovementItemFloat AS MIFloat_PriceSP
                                       ON MIFloat_PriceSP.MovementItemId = MovementItem.Id
                                      AND MIFloat_PriceSP.DescId = zc_MIFloat_PriceSP()
                                      AND MIFloat_PriceSP.ValueData > 0

         LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail 
                                        ON Object_Goods_Retail.GoodsMainId = MovementItem.ObjectId
                                       AND Object_Goods_Retail.RetailId = 4

     WHERE Movement.DescId = zc_Movement_GoodsSP()
       AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
    ;
    
    ANALYSE tmpGoodsSP_FS;    

    -- ��� ������������ - _tmpContainerCountPD
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpContainerCountPD'))
    THEN
        -- �������
        CREATE TEMP TABLE _tmpContainerCountPD (UnitId Integer, GoodsId Integer, PartionDateKindId Integer, Amount TFloat, Remains TFloat, PriceWithVAT TFloat, PartionDateDiscount TFloat, PricePartionDate TFloat) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpContainerCountPD;
    END IF;
    --

    INSERT INTO _tmpContainerCountPD (UnitId, GoodsId, PartionDateKindId, Amount, Remains, PriceWithVAT, PartionDateDiscount, PricePartionDate)
      WITH           -- ������� �� ������
            tmpMovementItemFloat AS (SELECT MIFloat_ContainerId.MovementItemId
									      , MIFloat_ContainerId.ValueData
                                 FROM MovementItemFloat AS MIFloat_ContainerId
                                 WHERE MIFloat_ContainerId.MovementItemId IN (SELECT MovementItemChildId.Id FROM MovementItemChildId) 
                                   AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                                )
          , ReserveContainer AS (SELECT MIFloat_ContainerId.ValueData::Integer      AS ContainerId
                                      , Sum(MovementItemChildId.Amount)::TFloat     AS Amount
                                 FROM MovementItemChildId
                                 INNER JOIN tmpMovementItemFloat AS MIFloat_ContainerId
                                                                  ON MIFloat_ContainerId.MovementItemId = MovementItemChildId.Id
                                                                -- AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                                 GROUP BY MIFloat_ContainerId.ValueData
                                )

             -- ������� �� ������
          , tmpPDContainerAll AS (SELECT Container.Id,
                                         Container.WhereObjectId,
                                         Container.ObjectId,
                                         Container.ParentId,
                                         Container.Amount                                        AS Amount,
                                         Container.Amount - COALESCE(ReserveContainer.Amount, 0) AS Remains,
                                         ContainerLinkObject.ObjectId                            AS PartionGoodsId,
                                         ReserveContainer.Amount                                 AS Reserve,
                                         _tmpGoodsMinPrice_List.GoodsGroupId                     AS GoodsGroupId
                                  FROM _tmpGoodsMinPrice_List

                                       INNER JOIN Container ON Container.ObjectId = _tmpGoodsMinPrice_List.GoodsId_retail
                                                           AND Container.DescId = zc_Container_CountPartionDate()
                                                           AND Container.WhereObjectId IN (SELECT _tmpUnitMinPrice_List.UnitId FROM _tmpUnitMinPrice_List)

                                       LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                       LEFT OUTER JOIN ReserveContainer ON ReserveContainer.ContainerID = Container.Id
                                  WHERE (Container.Amount - COALESCE(ReserveContainer.Amount, 0)) > 0
                                    AND _tmpGoodsMinPrice_List.isExpDateExcSite = False
                                    AND _tmpGoodsMinPrice_List.isPublished = True)
          , tmpPDContainer AS (SELECT Container.Id,
                                      Container.WhereObjectId,
                                      Container.ObjectId,
                                      Container.Amount,
                                      Container.Remains,
                                      COALESCE (ObjectFloat_PartionGoods_ValueMin.ValueData, 0)     AS PercentMin,
                                      COALESCE (ObjectFloat_PartionGoods_ValueLess.ValueData, 0)    AS PercentLess,
                                      COALESCE (ObjectFloat_PartionGoods_Value.ValueData, 0)        AS Percent,
                                      COALESCE (ObjectFloat_PartionGoods_PriceWithVAT.ValueData, 0) AS PriceWithVAT,
                                      CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0 AND
                                                COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                                 THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 ��� (��������� ��� �������)
                                           WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- ����������
                                           WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- ������ 1 ������
                                           WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_3  THEN zc_Enum_PartionDateKind_3()      -- ������ 3 �������
                                           WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- ������ 6 ������
                                           ELSE zc_Enum_PartionDateKind_Good() END  AS PartionDateKindId                               -- ����������� � ���������
                               FROM tmpPDContainerAll AS Container

                                    LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                         ON ObjectDate_ExpirationDate.ObjectId = Container.PartionGoodsId
                                                        AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                    LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                            ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = Container.PartionGoodsId
                                                           AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()

                                    LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_ValueMin
                                                          ON ObjectFloat_PartionGoods_ValueMin.ObjectId =  Container.PartionGoodsId
                                                         AND ObjectFloat_PartionGoods_ValueMin.DescId = zc_ObjectFloat_PartionGoods_ValueMin()
                                    LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_ValueLess
                                                          ON ObjectFloat_PartionGoods_ValueLess.ObjectId =  Container.PartionGoodsId
                                                         AND ObjectFloat_PartionGoods_ValueLess.DescId = zc_ObjectFloat_PartionGoods_ValueLess()
                                    LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_Value
                                                          ON ObjectFloat_PartionGoods_Value.ObjectId =  Container.PartionGoodsId
                                                         AND ObjectFloat_PartionGoods_Value.DescId = zc_ObjectFloat_PartionGoods_Value()

                                    LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_PriceWithVAT
                                                          ON ObjectFloat_PartionGoods_PriceWithVAT.ObjectId =  Container.PartionGoodsId
                                                         AND ObjectFloat_PartionGoods_PriceWithVAT.DescId = zc_ObjectFloat_PartionGoods_PriceWithVAT()
                               WHERE Container.GoodsGroupId <> 394744
                               )
          , tmpGoods_PD AS (SELECT DISTINCT tmpPDContainer.ObjectId AS GoodsId
                            FROM tmpPDContainer
                            WHERE tmpPDContainer.PriceWithVAT <= 15
                              AND tmpPDContainer.PartionDateKindId in (zc_Enum_PartionDateKind_6(), zc_Enum_PartionDateKind_3(), zc_Enum_PartionDateKind_1()))
          , tmpDataPD AS (SELECT Container.WhereObjectId
                               , Container.ObjectId
                               , Container.PartionDateKindId                                                  AS PartionDateKindId
                               , SUM (Container.Amount)                                                       AS Amount
                               , SUM (Container.Remains)                                                      AS Remains
                               , Max(Container.PriceWithVAT)                                                  AS PriceWithVAT
                               , MIN (CASE WHEN Container.PartionDateKindId IN (zc_Enum_PartionDateKind_Good(), zc_ObjectBoolean_PartionGoods_Cat_5())
                                           THEN 0
                                           WHEN Container.PartionDateKindId = zc_Enum_PartionDateKind_6()
                                           THEN Container.Percent
                                           WHEN Container.PartionDateKindId = zc_Enum_PartionDateKind_3()
                                           THEN Container.PercentLess
                                           ELSE Container.PercentMin END)::TFloat                             AS PartionDateDiscount
                          FROM tmpPDContainer AS Container
                          WHERE Container.PartionDateKindId <> zc_Enum_PartionDateKind_Good()
                          GROUP BY Container.WhereObjectId
                                 , Container.ObjectId
                                 , Container.PartionDateKindId)
          , tmpCashGoodsPriceWithVAT AS (WITH
                                 DD AS (SELECT DISTINCT Object_MarginCategoryItem_View.MarginPercent,
                                                        Object_MarginCategoryItem_View.MinPrice,
                                                        Object_MarginCategoryItem_View.MarginCategoryId,
                                                        ROW_NUMBER() OVER (PARTITION BY Object_MarginCategoryItem_View.MarginCategoryId
                                                                           ORDER BY Object_MarginCategoryItem_View.MinPrice) AS ORD
                                        FROM Object_MarginCategoryItem_View
                                             INNER JOIN Object AS Object_MarginCategoryItem ON Object_MarginCategoryItem.Id       = Object_MarginCategoryItem_View.Id
                                                                                           AND Object_MarginCategoryItem.isErased = FALSE
                                       )
                  , MarginCondition AS (SELECT
                                            D1.MarginCategoryId,
                                            D1.MarginPercent,
                                            D1.MinPrice,
                                            COALESCE(D2.MinPrice, 1000000) AS MaxPrice
                                        FROM DD AS D1
                                            LEFT OUTER JOIN DD AS D2 ON D1.MarginCategoryId = D2.MarginCategoryId AND D1.ORD = D2.ORD-1
                                       )

                  , JuridicalSettings AS (SELECT DISTINCT JuridicalSettings.JuridicalId, JuridicalSettings.ContractId, JuridicalSettings.isPriceCloseOrder
                                        FROM lpSelect_Object_JuridicalSettingsRetail (vbObjectId) AS JuridicalSettings
                                             LEFT JOIN Object AS Object_ContractSettings ON Object_ContractSettings.Id = JuridicalSettings.MainJuridicalId
                                        WHERE COALESCE (Object_ContractSettings.isErased, FALSE) = FALSE
                                         AND JuridicalSettings.MainJuridicalId <> 5603474
                                       )
                  , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                                        , ObjectFloat_NDSKind_NDS.ValueData
                                  FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                                  WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                                  )
                     -- !!!������ �� ������ tmpGoods_PD!!!
                   , tmpGoodsPartner AS (SELECT tmpGoods_PD.GoodsId                               AS GoodsId_retail -- ����� ����
                                              , Object_Goods.GoodsMainId                          AS GoodsId_main   -- ����� �������
                                              , Object_Goods_Juridical.Id                         AS GoodsId_jur    -- ����� ����������
                                              , Object_Goods_Juridical.Code                       AS GoodsCode_jur  -- ����� ����������
                                              , Object_Goods_Juridical.JuridicalId                AS JuridicalId    -- ���������
                                              , Object_Goods.isTop                                AS isTOP          -- ��� � ���. ����
                                              , COALESCE (Object_Goods.PercentMarkup, 0)          AS PercentMarkup  -- % ���. � ���. ����
                                              , COALESCE (Object_Goods.Price, 0)                  AS Price_retail   -- ������������� ���� � ���. ����
                                              , COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0)   AS NDS            -- NDS � ���. �������
                                         FROM tmpGoods_PD
                                              -- ������ - ����
                                              LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = tmpGoods_PD.GoodsId
                                              LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId
                                              LEFT JOIN Object_Goods_Juridical AS Object_Goods_Juridical ON Object_Goods_Juridical.GoodsMainId = Object_Goods.GoodsMainId

                                              LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                                   ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods_Main.NDSKindId
                                                                --   AND ObjectFloat_NDSKind_NDS.DescId   = zc_ObjectFloat_NDSKind_NDS()
                                        )

                   , _GoodsPriceAll AS (SELECT tmpGoodsPartner.GoodsId_retail         AS GoodsId, -- ����� ����
                                               tmpUnit.UnitId                         AS UnitId,
                                               zfCalc_SalePrice ((LoadPriceListItem.Price * (100 + tmpGoodsPartner.NDS) / 100),                         -- ���� � ���
                                                                 CASE WHEN COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0
                                                                          THEN MarginCondition.MarginPercent + COALESCE (ObjectFloat_Contract_Percent.ValueData, 0)
                                                                      ELSE MarginCondition.MarginPercent + COALESCE (ObjectFloat_Juridical_Percent.ValueData, 0)
                                                                 END,                                                                             -- % ������� � ���������
                                                                 COALESCE (tmpGoodsPartner.isTOP, FALSE),                                         -- ��� �������
                                                                 COALESCE (tmpGoodsPartner.PercentMarkup, 0),                                     -- % ������� � ������
                                                                 0.0, --ObjectFloat_Juridical_Percent.ValueData,                                  -- % ������������� � �� ���� ��� ����
                                                                 tmpGoodsPartner.Price_retail                                                            -- ���� � ������ (�������������)
                                                               )         :: TFloat AS Price,
                                               LoadPriceListItem.Price * (100 + tmpGoodsPartner.NDS)/100 AS PriceWithVAT

                                        FROM LoadPriceListItem

                                             INNER JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId

                                             LEFT JOIN JuridicalSettings
                                                     ON JuridicalSettings.JuridicalId = LoadPriceList.JuridicalId
                                                    AND JuridicalSettings.ContractId  = LoadPriceList.ContractId

                                             -- !!!���������� ������ ���� �������!!!
                                             INNER JOIN tmpGoodsPartner ON tmpGoodsPartner.JuridicalId   = LoadPriceList.JuridicalId
                                                                       AND tmpGoodsPartner.GoodsId_main  = LoadPriceListItem.GoodsId
                                                                       AND tmpGoodsPartner.GoodsCode_jur = LoadPriceListItem.GoodsCode

                                             LEFT JOIN (SELECT DISTINCT 
                                                               tmpPDContainer.ObjectId AS GoodsId
                                                             , tmpPDContainer.WhereObjectId AS UnitId 
                                                        FROM tmpPDContainer) AS tmpUnit 
                                                                             ON tmpUnit.GoodsId = tmpGoodsPartner.GoodsId_retail
                                                                             
                                            LEFT JOIN _tmpUnitMinPrice_List ON _tmpUnitMinPrice_List.UnitId = tmpUnit.UnitId 
                                             
                                             LEFT JOIN ObjectFloat AS ObjectFloat_Juridical_Percent
                                                                   ON ObjectFloat_Juridical_Percent.ObjectId = LoadPriceList.JuridicalId
                                                                  AND ObjectFloat_Juridical_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

                                             LEFT JOIN ObjectFloat AS ObjectFloat_Contract_Percent
                                                                   ON ObjectFloat_Contract_Percent.ObjectId = LoadPriceList.ContractId
                                                                  AND ObjectFloat_Contract_Percent.DescId = zc_ObjectFloat_Contract_Percent()

                                             LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink
                                                                                      ON Object_MarginCategoryLink.UnitId = tmpUnit.UnitId 
                                                                                     AND Object_MarginCategoryLink.JuridicalId = LoadPriceList.JuridicalId

                                             LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink_all
                                                                                      ON COALESCE (Object_MarginCategoryLink_all.UnitId, 0) = 0
                                                                                     AND Object_MarginCategoryLink_all.JuridicalId = LoadPriceList.JuridicalId
                                                                                     AND Object_MarginCategoryLink_all.isErased    = FALSE
                                                                                     AND Object_MarginCategoryLink.JuridicalId IS NULL

                                             LEFT JOIN MarginCondition ON MarginCondition.MarginCategoryId = COALESCE (Object_MarginCategoryLink.MarginCategoryId, Object_MarginCategoryLink_all.MarginCategoryId)
                                                                     AND (LoadPriceListItem.Price * (100 + tmpGoodsPartner.NDS)/100)::TFloat BETWEEN MarginCondition.MinPrice AND MarginCondition.MaxPrice

                                        WHERE COALESCE(JuridicalSettings.isPriceCloseOrder, TRUE)  = FALSE
                                          AND (LoadPriceList.AreaId = 0 OR COALESCE (LoadPriceList.AreaId, 0) = _tmpUnitMinPrice_List.AreaId OR COALESCE(_tmpUnitMinPrice_List.AreaId, 0) = 0
                                            OR COALESCE (LoadPriceList.AreaId, 0) = zc_Area_Basis()
                                              )
                                       )
                              , GoodsPriceAll AS (SELECT
                                                       ROW_NUMBER() OVER (PARTITION BY _GoodsPriceAll.GoodsId, _GoodsPriceAll.UnitId ORDER BY _GoodsPriceAll.Price)::Integer AS Ord,
                                                       _GoodsPriceAll.GoodsId           AS GoodsId,
                                                       _GoodsPriceAll.UnitId            AS UnitId,
                                                       _GoodsPriceAll.PriceWithVAT      AS PriceWithVAT
                                                  FROM _GoodsPriceAll
                                                 )
                            -- ��������� - ����-����
                            SELECT GoodsPriceAll.GoodsId      AS GoodsId,
                                   GoodsPriceAll.UnitId       AS UnitId,
                                   GoodsPriceAll.PriceWithVAT AS PriceWithVAT
                            FROM GoodsPriceAll
                            WHERE Ord = 1
                           )
                                                
          SELECT  
                 Container.WhereObjectId
               , Container.ObjectId
               , Container.PartionDateKindId
               , Container.Amount
               , Container.Remains
               , CASE WHEN Container.PriceWithVAT <= 15
                      THEN COALESCE (tmpCashGoodsPriceWithVAT.PriceWithVAT, Container.PriceWithVAT)
                      ELSE Container.PriceWithVAT END::TFloat       AS PriceWithVAT
               , Container.PartionDateDiscount

               , CASE WHEN zfCalc_PriceCash(Price_Unit.Price, 
                         CASE WHEN tmpGoodsSP_FS.GoodsId IS NULL OR tmpGoodsSP_FS.isElectronicPrescript = True THEN FALSE ELSE TRUE END OR
                         COALESCE(tmpGoodsDiscount.GoodsId, 0) <> 0) > CASE WHEN Container.PriceWithVAT <= 15
                                                                       THEN COALESCE (tmpCashGoodsPriceWithVAT.PriceWithVAT, Container.PriceWithVAT)
                                                                       ELSE Container.PriceWithVAT END
                         AND CASE WHEN Container.PriceWithVAT <= 15
                                  THEN COALESCE (tmpCashGoodsPriceWithVAT.PriceWithVAT, Container.PriceWithVAT)
                                  ELSE Container.PriceWithVAT END <= vbPriceSamples 
                         AND vbPriceSamples > 0
                         AND CASE WHEN Container.PriceWithVAT <= 15
                                  THEN COALESCE (tmpCashGoodsPriceWithVAT.PriceWithVAT, Container.PriceWithVAT)
                                  ELSE Container.PriceWithVAT END > 0
                         AND Container.PartionDateKindId IN (zc_Enum_PartionDateKind_1(), zc_Enum_PartionDateKind_3(), zc_Enum_PartionDateKind_6())
                      THEN ROUND(zfCalc_PriceCash(Price_Unit.Price *
                                 CASE WHEN Container.PartionDateKindId = zc_Enum_PartionDateKind_6() THEN 100.0 - vbSamples21
                                      WHEN Container.PartionDateKindId = zc_Enum_PartionDateKind_3() THEN 100.0 - vbSamples22
                                      WHEN Container.PartionDateKindId = zc_Enum_PartionDateKind_1() THEN 100.0 - vbSamples3
                                      ELSE 100 END  / 100, 
                                 CASE WHEN tmpGoodsSP_FS.GoodsId IS NULL OR tmpGoodsSP_FS.isElectronicPrescript = True THEN FALSE ELSE TRUE END), 2)
                      WHEN Container.PartionDateKindId = zc_Enum_PartionDateKind_6() AND COALESCE(Container.PartionDateDiscount, 0) > 0 AND
                         zfCalc_PriceCash(Price_Unit.Price, 
                         CASE WHEN tmpGoodsSP_FS.GoodsId IS NULL OR tmpGoodsSP_FS.isElectronicPrescript = True THEN FALSE ELSE TRUE END OR
                         COALESCE(tmpGoodsDiscount.GoodsId, 0) <> 0) > CASE WHEN Container.PriceWithVAT <= 15
                                                                            THEN COALESCE (tmpCashGoodsPriceWithVAT.PriceWithVAT, Container.PriceWithVAT)
                                                                            ELSE Container.PriceWithVAT END
                         AND CASE WHEN Container.PriceWithVAT <= 15
                                  THEN COALESCE (tmpCashGoodsPriceWithVAT.PriceWithVAT, Container.PriceWithVAT)
                                  ELSE Container.PriceWithVAT END > 0
                      THEN ROUND(zfCalc_PriceCash(Price_Unit.Price, 
                         CASE WHEN tmpGoodsSP_FS.GoodsId IS NULL OR tmpGoodsSP_FS.isElectronicPrescript = True THEN FALSE ELSE TRUE END OR
                         COALESCE(tmpGoodsDiscount.GoodsId, 0) <> 0) - (zfCalc_PriceCash(Price_Unit.Price, 
                         CASE WHEN tmpGoodsSP_FS.GoodsId IS NULL OR tmpGoodsSP_FS.isElectronicPrescript = True THEN FALSE ELSE TRUE END OR
                         COALESCE(tmpGoodsDiscount.GoodsId, 0) <> 0) - CASE WHEN Container.PriceWithVAT <= 15
                                                                            THEN COALESCE (tmpCashGoodsPriceWithVAT.PriceWithVAT, Container.PriceWithVAT)
                                                                            ELSE Container.PriceWithVAT END) *
                                 Container.PartionDateDiscount / 100, 2)
                      WHEN Container.PartionDateKindId IN (zc_Enum_PartionDateKind_1(), zc_Enum_PartionDateKind_3()) AND COALESCE(Container.PartionDateDiscount, 0) > 0
                      THEN zfCalc_PriceCash(Round(Price_Unit.Price * (100.0 - COALESCE(Container.PartionDateDiscount, 0)) / 100.0, 2), 
                                       CASE WHEN tmpGoodsSP_FS.GoodsId IS NULL OR tmpGoodsSP_FS.isElectronicPrescript = True OR COALESCE (tmpGoodsSP_FS.PriceSP, 0) = 0 
                                            THEN FALSE ELSE TRUE END OR
                                       COALESCE(tmpGoodsDiscount.GoodsId, 0) <> 0)
                      WHEN Container.PartionDateKindId IN (zc_Enum_PartionDateKind_Cat_5()) AND COALESCE(vbCat_5, 0) > 0
                      THEN zfCalc_PriceCash(Round(Price_Unit.Price * (100.0 - vbCat_5) / 100.0, 2), 
                                       CASE WHEN tmpGoodsSP_FS.GoodsId IS NULL OR tmpGoodsSP_FS.isElectronicPrescript = True OR COALESCE (tmpGoodsSP_FS.PriceSP, 0) = 0 
                                            THEN FALSE ELSE TRUE END OR
                                       COALESCE(tmpGoodsDiscount.GoodsId, 0) <> 0)
                      ELSE zfCalc_PriceCash(Price_Unit.Price, 
                         CASE WHEN tmpGoodsSP_FS.GoodsId IS NULL OR tmpGoodsSP_FS.isElectronicPrescript = True THEN FALSE ELSE TRUE END OR
                         COALESCE(tmpGoodsDiscount.GoodsId, 0) <> 0)
                      END :: TFloat AS PricePartionDate

          FROM tmpDataPD AS Container 

               LEFT JOIN tmpCashGoodsPriceWithVAT ON tmpCashGoodsPriceWithVAT.GoodsId = Container.ObjectId
                                                 AND tmpCashGoodsPriceWithVAT.UnitId = Container.WhereObjectId
               
               LEFT JOIN Price_Unit_all AS Price_Unit     
                                        ON Price_Unit.GoodsId     = Container.ObjectId
                                       AND Price_Unit.UnitId      = Container.WhereObjectId

               LEFT JOIN tmpGoodsDiscount AS tmpGoodsDiscount
                                          ON tmpGoodsDiscount.GoodsId = Container.ObjectId
                                         AND tmpGoodsDiscount.UnitId = Container.WhereObjectId
               -- ��� ������
               LEFT JOIN tmpGoodsSP_FS ON tmpGoodsSP_FS.GoodsId = Container.ObjectId
                                   AND tmpGoodsSP_FS.Ord     = 1 -- � �/� - �� ������ ������
          ;

    -- !!!�����������!!!

    -- ���������
    RETURN QUERY
       WITH tmpMI_Deferred AS
               (SELECT Movement.UnitId
                     , MovementItem.GoodsId
                     , SUM (MovementItem.Amount)          AS Amount
                FROM tmpMI_DeferredAll AS MovementItem
                
                     INNER JOIN _tmpMovementCheck AS Movement ON Movement.ID = MovementItem.MovementId

                GROUP BY Movement.UnitId
                       , MovementItem.GoodsId
               )
          , MarginCategory_Unit AS
               (SELECT tmp.UnitId
                     , tmp.MarginCategoryId
                FROM (SELECT tmpList.UnitId
                           , ObjectLink_MarginCategory.ChildObjectId AS MarginCategoryId
                        -- , ROW_NUMBER() OVER (PARTITION BY tmpList.UnitId, ObjectLink_MarginCategory.ChildObjectId ORDER BY tmpList.UnitId, ObjectLink_MarginCategory.ChildObjectId) AS Ord
                           , ROW_NUMBER() OVER (PARTITION BY tmpList.UnitId ORDER BY tmpList.UnitId, ObjectLink_MarginCategory.ChildObjectId) AS Ord
                      FROM _tmpUnitMinPrice_List AS tmpList
                           INNER JOIN ObjectLink AS ObjectLink_MarginCategoryLink_Unit
                                                 ON ObjectLink_MarginCategoryLink_Unit.ChildObjectId = tmpList.UnitId
                                                AND ObjectLink_MarginCategoryLink_Unit.DescId        = zc_ObjectLink_MarginCategoryLink_Unit()
                           LEFT JOIN ObjectLink AS ObjectLink_MarginCategory
                                                ON ObjectLink_MarginCategory.ObjectId = ObjectLink_MarginCategoryLink_Unit.ObjectId
                                               AND ObjectLink_MarginCategory.DescId   = zc_ObjectLink_MarginCategoryLink_MarginCategory()
                           LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                                 ON ObjectFloat_Percent.ObjectId = ObjectLink_MarginCategory.ChildObjectId
                                                AND ObjectFloat_Percent.DescId   = zc_ObjectFloat_MarginCategory_Percent()
                      WHERE COALESCE (ObjectFloat_Percent.ValueData, 0) = 0 -- !!!��� ��� �����!!!
                     ) AS tmp
                WHERE tmp.Ord = 1 -- !!!������ ���� ���������!!!
               )
          , MarginCategory_all AS
               (SELECT DISTINCT
                       tmp.UnitId
                     , tmp.MarginCategoryId
                     , ObjectFloat_MarginPercent.ValueData AS MarginPercent
                     , ObjectFloat_MinPrice.ValueData      AS MinPrice
                     , ROW_NUMBER() OVER (PARTITION BY tmp.UnitId, tmp.MarginCategoryId ORDER BY tmp.UnitId, tmp.MarginCategoryId, ObjectFloat_MinPrice.ValueData) AS ORD
                FROM (SELECT MarginCategory_Unit.UnitId, MarginCategory_Unit.MarginCategoryId FROM MarginCategory_Unit
                     UNION ALL
                      SELECT 0 AS UnitId, vbMarginCategoryId_site AS MarginCategoryId
                     ) AS tmp
                     -- INNER JOIN Object_MarginCategoryItem_View ON Object_MarginCategoryItem_View.MarginCategoryId = tmp.MarginCategoryId
                     INNER JOIN ObjectLink AS ObjectLink_MarginCategoryItem_MarginCategory
                                           ON ObjectLink_MarginCategoryItem_MarginCategory.ChildObjectId = tmp.MarginCategoryId
                                          AND ObjectLink_MarginCategoryItem_MarginCategory.DescId = zc_ObjectLink_MarginCategoryItem_MarginCategory()
                     INNER JOIN Object ON Object.Id = ObjectLink_MarginCategoryItem_MarginCategory.ObjectId
                                      AND Object.isErased = FALSE
                     LEFT JOIN ObjectFloat AS ObjectFloat_MinPrice
                                           ON ObjectFloat_MinPrice.ObjectId =ObjectLink_MarginCategoryItem_MarginCategory.ObjectId
                                          AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_MarginCategoryItem_MinPrice()
                     LEFT JOIN ObjectFloat AS ObjectFloat_MarginPercent
                                           ON ObjectFloat_MarginPercent.ObjectId = ObjectLink_MarginCategoryItem_MarginCategory.ObjectId
                                          AND ObjectFloat_MarginPercent.DescId = zc_ObjectFloat_MarginCategoryItem_MarginPercent()

               )
          , MarginCategory AS
               (SELECT DISTINCT
                       MarginCategory_all.UnitId
                     , MarginCategory_all.MarginCategoryId
                     , MarginCategory_all.MarginPercent
                     , MarginCategory_all.MinPrice
                     , COALESCE (MarginCategory_all_next.MinPrice, 1000000) AS MaxPrice
                FROM MarginCategory_all
                     LEFT JOIN MarginCategory_all AS MarginCategory_all_next ON MarginCategory_all_next.UnitId           = MarginCategory_all.UnitId
                                                                            AND MarginCategory_all_next.MarginCategoryId = MarginCategory_all.MarginCategoryId
                                                                            AND MarginCategory_all_next.ORD = MarginCategory_all.ORD + 1
                WHERE MarginCategory_all.MarginCategoryId <> vbMarginCategoryId_site
               )
          , MarginCategory_site AS
               (SELECT DISTINCT
                       MarginCategory_all.MarginPercent
                     , MarginCategory_all.MinPrice
                     , COALESCE (MarginCategory_all_next.MinPrice, 1000000) AS MaxPrice
                FROM MarginCategory_all
                     LEFT JOIN MarginCategory_all AS MarginCategory_all_next ON MarginCategory_all_next.MarginCategoryId = MarginCategory_all.MarginCategoryId
                                                                            AND MarginCategory_all_next.ORD = MarginCategory_all.ORD + 1
                WHERE MarginCategory_all.MarginCategoryId = vbMarginCategoryId_site
               )
          , tmpPDGoodsRemains AS
               (SELECT PDGoodsRemains.GoodsId, PDGoodsRemains.UnitId, SUM( PDGoodsRemains.Amount) AS Amount
                FROM _tmpContainerCountPD AS PDGoodsRemains
                GROUP BY  PDGoodsRemains.GoodsId, PDGoodsRemains.UnitId
                )
          , tmpNDSKind AS
                (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                       , ObjectFloat_NDSKind_NDS.ValueData
                 FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                 WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                )
          /*, tmpPrice_Site AS (SELECT Object_PriceSite.Id                        AS Id
                                   , CASE WHEN PriceSite_DiscontStart.ValueData IS NOT NULL
                                           AND PriceSite_DiscontEnd.ValueData IS NOT NULL  
                                           AND PriceSite_DiscontStart.ValueData <= CURRENT_DATE
                                           AND PriceSite_DiscontEnd.ValueData >= CURRENT_DATE
                                           AND COALESCE (PriceSite_DiscontAmount.ValueData, 0) > 0
                                          THEN ROUND(Price_Value.ValueData - COALESCE (PriceSite_DiscontAmount.ValueData, 0), 2)
                                          WHEN PriceSite_DiscontStart.ValueData IS NOT NULL
                                           AND PriceSite_DiscontEnd.ValueData IS NOT NULL  
                                           AND PriceSite_DiscontStart.ValueData <= CURRENT_DATE
                                           AND PriceSite_DiscontEnd.ValueData >= CURRENT_DATE
                                           AND COALESCE (PriceSite_DiscontPercent.ValueData, 0) > 0 
                                          THEN ROUND(Price_Value.ValueData * (100 - COALESCE (PriceSite_DiscontPercent.ValueData, 0)) / 100, 1)
                                          ELSE ROUND(Price_Value.ValueData, 2) END::TFloat     AS Price
                                   , Price_Goods.ChildObjectId                  AS GoodsId
                                   , PriceSite_DiscontStart.ValueData           AS DiscontStart
                                   , PriceSite_DiscontEnd.ValueData             AS DiscontEnd
                                   , PriceSite_DiscontAmount.ValueData          AS DiscontAmount
                                   , PriceSite_DiscontPercent.ValueData         AS DiscontPercent
                              FROM Object AS Object_PriceSite
                                   INNER JOIN ObjectLink AS Price_Goods
                                           ON Price_Goods.ObjectId = Object_PriceSite.Id
                                          AND Price_Goods.DescId = zc_ObjectLink_PriceSite_Goods()
                                   INNER JOIN (SELECT DISTINCT _tmpGoodsMinPrice_List.GoodsId FROM _tmpGoodsMinPrice_List) AS _List ON _List.GoodsId = Price_Goods.ChildObjectId  
                                   LEFT JOIN ObjectFloat AS Price_Value
                                          ON Price_Value.ObjectId = Object_PriceSite.Id
                                         AND Price_Value.DescId = zc_ObjectFloat_PriceSite_Value()
                                   LEFT JOIN ObjectDate AS PriceSite_DiscontStart
                                                        ON PriceSite_DiscontStart.ObjectId = Object_PriceSite.Id
                                                       AND PriceSite_DiscontStart.DescId = zc_ObjectDate_PriceSite_DiscontStart()
                                   LEFT JOIN ObjectDate AS PriceSite_DiscontEnd
                                                        ON PriceSite_DiscontEnd.ObjectId = Object_PriceSite.Id
                                                       AND PriceSite_DiscontEnd.DescId = zc_ObjectDate_PriceSite_DiscontEnd()
                                   LEFT JOIN ObjectFloat AS PriceSite_DiscontAmount
                                                         ON PriceSite_DiscontAmount.ObjectId = Object_PriceSite.Id
                                                        AND PriceSite_DiscontAmount.DescId = zc_ObjectFloat_PriceSite_DiscontAmount()
                                   LEFT JOIN ObjectFloat AS PriceSite_DiscontPercent
                                                         ON PriceSite_DiscontPercent.ObjectId = Object_PriceSite.Id
                                                        AND PriceSite_DiscontPercent.DescId = zc_ObjectFloat_PriceSite_DiscontPercent()
                              WHERE Object_PriceSite.DescId = zc_Object_PriceSite()
                                AND Price_Goods.ChildObjectId NOT IN (SELECT DISTINCT ObjectLink_BarCode_Goods.ChildObjectId  AS GoodsId
                                                                      FROM Object AS Object_BarCode
                                                                           LEFT JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                                                                ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                                                               AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                                                           LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                                                                ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                                                               AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                                                           LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId           

                                                                      WHERE Object_BarCode.DescId = zc_Object_BarCode()
                                                                        AND Object_BarCode.isErased = False
                                                                        AND Object_Object.isErased = False)
                                AND Price_Goods.ChildObjectId NOT IN (SELECT Promo.GoodsId
                                                                      FROM gpSelect_MovementItem_Promo(inMovementId := 20813880 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3') as Promo
                                                                      )
                                AND FALSE
                              )*/
                              
       , tmpRemainsDiscount AS (SELECT Container.ObjectId         AS GoodsId
                                     , Container.WhereObjectId    AS UnitId
                                     , SUM(CASE WHEN COALESCE (ContainerPD.Id, 0) = 0 AND COALESCE (DiscountExternalSupplier.DiscountExternalId, 0) <> 0 
                                                     AND Container.Amount >= 1 THEN FLOOR(Container.Amount) ELSE 0 END) AS AmountDiscount
                                     , SUM(Container.Amount)      AS Amount
                                FROM (SELECT DISTINCT tmpGoodsDiscount.GoodsId, tmpGoodsDiscount.DiscountExternalId FROM tmpGoodsDiscount) AS GoodsDiscount
                                
                                     JOIN Container ON Container.ObjectId = GoodsDiscount.GoodsId
                                                   AND Container.DescId = zc_Container_Count() 
                                                   AND Container.Amount > 0
   
                                     JOIN containerlinkobject AS CLI_MI
                                                          ON CLI_MI.containerid = Container.Id
                                                         AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                                     LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                     -- ������� �������
                                     LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                     -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                                     LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                 ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                                AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                     -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                                     LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                                                          -- AND 1=0
                                     LEFT OUTER JOIN MovementItemDate AS MIDate_ExpirationDate
                                                                      ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                                     AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                     LEFT OUTER JOIN Movement AS Movement_Income
                                                              ON Movement_Income.Id = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)  --Object_PartionMovementItem.ObjectCode

                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                  ON MovementLinkObject_From.MovementId = COALESCE (MI_Income_find.MovementId ,MI_Income.MovementId)
                                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                        
                                     LEFT JOIN Container AS ContainerPD
                                                         ON ContainerPD.ParentId = Container.Id
                                                        AND ContainerPD.Amount > 0
                                                        AND ContainerPD.DescId = zc_Container_CountPartionDate()
                                                        
                                     LEFT JOIN gpSelect_Object_DiscountExternalSupplier(inIsErased := False, inSession := inSession) AS DiscountExternalSupplier
                                                                                                                ON DiscountExternalSupplier.isErased = False
                                                                                                               AND DiscountExternalSupplier.DiscountExternalId =  GoodsDiscount.DiscountExternalId
                                                                                                               AND DiscountExternalSupplier.JuridicalId = MovementLinkObject_From.ObjectId
                                                        
                               GROUP BY Container.ObjectId
                                      , Container.WhereObjectId
         )
       -- ���������� ����������� ���������
       , tmpMovementTP AS (SELECT MovementItemMaster.ObjectId      AS GoodsId
                                , MovementLinkObject_Unit.ObjectId AS UnitId
                                , SUM(-MovementItemMaster.Amount)  AS Amount
                           FROM Movement AS Movement

                                INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                               
                                INNER JOIN MovementItem AS MovementItemMaster
                                                        ON MovementItemMaster.MovementId = Movement.Id
                                                       AND MovementItemMaster.DescId     = zc_MI_Master()
                                                       AND MovementItemMaster.isErased   = FALSE
                                                       AND MovementItemMaster.Amount     < 0
                                                         
                                INNER JOIN MovementItemBoolean AS MIBoolean_Deferred
                                                               ON MIBoolean_Deferred.MovementItemId = MovementItemMaster.Id
                                                              AND MIBoolean_Deferred.DescId         = zc_MIBoolean_Deferred()
                                                              AND MIBoolean_Deferred.ValueData      = TRUE
                                                               
                           WHERE Movement.DescId = zc_Movement_TechnicalRediscount()
                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
                           GROUP BY MovementItemMaster.ObjectId
                                  , MovementLinkObject_Unit.ObjectId)                      
          , tmpPromoBonus AS (SELECT PromoBonus.GoodsID
                                   , PromoBonus.UnitID
                                   , PromoBonus.MarginPercent
                                   , PromoBonus.BonusInetOrder 
                              FROM gpSelect_PromoBonus_MarginPercent(inUnitId := 0,  inSession := inSession) AS PromoBonus 
                              WHERE PromoBonus.BonusInetOrder > 0)

        SELECT Object_Goods.Id                                                     AS Id

             , CASE WHEN Object_Goods.isErased = TRUE THEN 1 ELSE 0 END::Integer   AS deleted

             , tmpList.UnitId                                                      AS UnitId
             , CASE WHEN (tmpList2.Amount - COALESCE (tmpMI_Deferred.Amount, 0) -
                                            COALESCE (PDGoodsRemains.Amount, 0) -
                                            COALESCE (Reserve_TP.Amount, 0)) <= 0 THEN NULL
                    WHEN COALESCE (GoodsDiscount.DiscountProcent, 0) > 0 AND
                         (RemainsDiscount.AmountDiscount - COALESCE (tmpMI_Deferred.Amount, 0) -
                                            COALESCE (PDGoodsRemains.Amount, 0) -
                                            COALESCE (Reserve_TP.Amount, 0)) <= 0 THEN NULL
                    WHEN COALESCE (GoodsDiscount.DiscountProcent, 0) > 0 THEN RemainsDiscount.AmountDiscount - COALESCE (tmpMI_Deferred.Amount, 0) -
                                            COALESCE (PDGoodsRemains.Amount, 0) -
                                            COALESCE (Reserve_TP.Amount, 0)
                    ELSE (tmpList2.Amount - COALESCE (tmpMI_Deferred.Amount, 0) -
                                            COALESCE (PDGoodsRemains.Amount, 0) -
                                            COALESCE (Reserve_TP.Amount, 0))
                    END ::TFloat                                                   AS Remains

             , CASE WHEN (COALESCE (tmpList2.Amount, 0) - COALESCE (tmpMI_Deferred.Amount, 0) - COALESCE (Reserve_TP.Amount, 0)) <=  0
                    THEN Null
                    ELSE zfCalc_PriceCash(Price_Unit.PriceSale,
                                          CASE WHEN tmpGoodsSP_FS.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                          COALESCE(GoodsDiscount.GoodsId, 0) <> 0) END :: TFloat  AS Price_unit
             
             
             , COALESCE (NULLIF(CASE WHEN COALESCE(Price_Unit.PriceChange, 0) = 0 AND Price_Unit.isTop = FALSE AND COALESCE (tmpPromoBonus.BonusInetOrder, 0) > 0
                                THEN zfCalc_PriceCash(Price_Unit.Price * 100.0 / (100.0 + tmpPromoBonus.MarginPercent) * 
                                                     (100.0 - tmpPromoBonus.BonusInetOrder + tmpPromoBonus.MarginPercent) / 100,
                                                      CASE WHEN tmpGoodsSP_FS.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                                      COALESCE(GoodsDiscount.GoodsId, 0) <> 0)
                                ELSE NULL END, 0),
               zfCalc_PriceCash(CASE WHEN COALESCE((tmpList2.Amount - COALESCE (tmpMI_Deferred.Amount, 0) -
                                                   COALESCE (PDGoodsRemains.Amount, 0) -
                                                   COALESCE (Reserve_TP.Amount, 0)), 0) <= 0 
                                     THEN Null
                                     WHEN tmpList.GoodsId_retail = tmpList.GoodsId
                                     THEN COALESCE (/*tmpPrice_Site.Price,*/ Price_Unit.PriceChange, Price_Unit.Price)
                                     ELSE COALESCE(Price_Unit.PriceChange, Price_Unit.Price) END,
                                     CASE WHEN tmpGoodsSP_FS.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                     COALESCE(GoodsDiscount.GoodsId, 0) <> 0)) :: TFloat AS Price_unit_sale
                                     
             , ROUND (MinPrice_List.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100) *
                     (1 + CASE WHEN Price_Unit.IsTop = TRUE AND COALESCE(Price_Unit.PercentMarkup, 0) > 0 
                               THEN Price_Unit.PercentMarkup 
                               ELSE COALESCE (MarginCategory.MarginPercent, 0) END / 100), 2) :: TFloat  AS Price_min

             , CASE WHEN tmpList.GoodsId_retail = tmpList.GoodsId
                    THEN ROUND (MinPrice_List.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100) *
                               (1 + CASE WHEN Price_Unit.IsTop = TRUE AND COALESCE(Price_Unit.PercentMarkup, 0) > 0 
                                         THEN Price_Unit.PercentMarkup 
                                         ELSE MarginCategory.MarginPercent END / 100), 2)
                    ELSE ROUND (CASE WHEN vbSiteDiscount = 0 THEN ROUND (MinPrice_List.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100) *
                               (1 + CASE WHEN Price_Unit.IsTop = TRUE AND COALESCE(Price_Unit.PercentMarkup, 0) > 0 THEN Price_Unit.PercentMarkup ELSE COALESCE (MarginCategory.MarginPercent, 0) END / 100), 2)
                               ELSE CEIL(ROUND (MinPrice_List.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100) *
                               (1 + CASE WHEN Price_Unit.IsTop = TRUE AND COALESCE(Price_Unit.PercentMarkup, 0) > 0 THEN Price_Unit.PercentMarkup ELSE COALESCE (MarginCategory.MarginPercent, 0) END / 100), 2) *
                               (100.0 - vbSiteDiscount) / 10.0) / 10.0 END, 2) END :: TFloat AS Price_min_sale
                        
             , CASE WHEN tmpList.GoodsId_retail = tmpList.GoodsId
                    THEN ROUND (MinPrice_List_D.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100) * (1 + COALESCE (MarginCategory_site.MarginPercent, 0) / 100), 2)
                    ELSE ROUND (MinPrice_List_D.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100) * (1 + COALESCE (MarginCategory_site.MarginPercent, 0) / 100), 2) END  :: TFloat  AS Price_minD

/*             , ROUND (CASE WHEN vbSiteDiscount = 0 THEN ROUND (MinPrice_List.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100) *
                        (1 + CASE WHEN Price_Unit.IsTop = TRUE AND COALESCE(Price_Unit.PercentMarkup, 0) > 0 THEN Price_Unit.PercentMarkup ELSE COALESCE (MarginCategory.MarginPercent, 0) END / 100), 2)
                        ELSE CEIL(ROUND (MinPrice_List.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100) *
                        (1 + CASE WHEN Price_Unit.IsTop = TRUE AND COALESCE(Price_Unit.PercentMarkup, 0) > 0 THEN Price_Unit.PercentMarkup ELSE COALESCE (MarginCategory.MarginPercent, 0) END / 100), 2) *
                        (100.0 - vbSiteDiscount) / 10.0) / 10.0 END, 2) :: TFloat AS Price_min_sale
             , ROUND (MinPrice_List_D.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100) * (1 + COALESCE (MarginCategory_site.MarginPercent, 0) / 100), 2) :: TFloat  AS Price_minD*/
             
             
             , CASE WHEN COALESCE((tmpList2.Amount - COALESCE (tmpMI_Deferred.Amount, 0) - COALESCE (PDGoodsRemains.Amount, 0)), 0) <= 0
                      OR COALESCE (RemainsDiscount.AmountDiscount, 0) = 0
                    THEN NULL
                    WHEN COALESCE(Price_Unit.Price, 0) > 0 AND COALESCE (GoodsDiscount.DiscountProcent, 0) > 0 AND GoodsDiscount.isDiscountSite = TRUE
                    THEN ROUND(CASE WHEN COALESCE(GoodsDiscount.MaxPrice, 0) = 0 OR Price_Unit.Price < GoodsDiscount.MaxPrice
                                    THEN Price_Unit.Price ELSE GoodsDiscount.MaxPrice END * (100 - GoodsDiscount.DiscountProcent) / 100, 1)
                    ELSE NULL END  :: TFloat   AS Price_Discount
             , MinPrice_List.JuridicalId
             , MinPrice_List.JuridicalName
             , MinPrice_List.ContractId
             , Object_Contract.ValueData       AS ContractName
             , MinPrice_List.PartionGoodsDate  AS ExpirationDate





             , ContainerCountPD_1.PartionDateKindId    AS PartionDateKindId_1
             , ContainerCountPD_1.Remains::TFloat AS Remains_1
             , CASE WHEN COALESCE (ContainerCountPD_1.Remains, 0) <=  0
                    THEN Null
                    ELSE zfCalc_PriceCash(Price_Unit.PriceSale,
                                          CASE WHEN tmpGoodsSP_FS.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                          COALESCE(GoodsDiscount.GoodsId, 0) <> 0) END :: TFloat  AS  Price_unit_1
             , CASE WHEN COALESCE (ContainerCountPD_1.Remains, 0) <=  0
                    THEN Null
                    WHEN COALESCE (RemainsDiscount.GoodsId, 0) <> 0 AND COALESCE(Price_Unit.Price, 0) > 0 AND 
                         COALESCE (GoodsDiscount.DiscountProcent, 0) > 0 AND GoodsDiscount.isDiscountSite = TRUE
                    THEN ROUND(CASE WHEN COALESCE(GoodsDiscount.MaxPrice, 0) = 0 OR Price_Unit.Price < GoodsDiscount.MaxPrice
                                    THEN Price_Unit.Price ELSE GoodsDiscount.MaxPrice END * (100 - GoodsDiscount.DiscountProcent) / 100, 1)
                    WHEN Price_Unit.isTop = TRUE
                    THEN zfCalc_PriceCash(CASE WHEN tmpList.GoodsId_retail = tmpList.GoodsId
                                               THEN Price_Unit.Price -- COALESCE (tmpPrice_Site.Price, Price_Unit.Price)
                                               ELSE Price_Unit.Price END,
                                               CASE WHEN tmpGoodsSP_FS.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                               COALESCE(GoodsDiscount.GoodsId, 0) <> 0)
                    WHEN COALESCE(tmpPromoBonus.BonusInetOrder, 0) <> 0
                     AND Object_Goods_Retail.IsTop = False 
                     AND (COALESCE(Price_Unit.PriceChange, 0) = 0 AND
                          COALESCE(Price_Unit.FixPercent, 0) = 0 AND
                          COALESCE(Price_Unit.FixDiscount, 0) = 0 OR
                          COALESCE(Price_Unit.Multiplicity, 0) > 1)
                     AND COALESCE ( ContainerCountPD_1.PricePartionDate, 0) > 0
                     AND COALESCE ( ContainerCountPD_1.PricePartionDate, 0) > 
                          zfCalc_PriceCash(Round(Price_Unit.Price * 100.0 / (100.0 + tmpPromoBonus.MarginPercent) * 
                                          (100.0 - tmpPromoBonus.BonusInetOrder + tmpPromoBonus.MarginPercent) / 100, 2), 
                                          CASE WHEN tmpGoodsSP_FS.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                               COALESCE(GoodsDiscount.GoodsId, 0) <> 0)
                    THEN zfCalc_PriceCash(Round(Price_Unit.Price * 100.0 / (100.0 + tmpPromoBonus.MarginPercent) * 
                                          (100.0 - tmpPromoBonus.BonusInetOrder + tmpPromoBonus.MarginPercent) / 100, 2), 
                                          CASE WHEN tmpGoodsSP_FS.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                               COALESCE(GoodsDiscount.GoodsId, 0) <> 0)
                    ELSE ContainerCountPD_1.PricePartionDate
                    END                                  :: TFloat AS  Price_unit_sale_1
               
               
             , ContainerCountPD_3.PartionDateKindId    AS PartionDateKindId_3
             , ContainerCountPD_3.Remains              AS Remains_3
             , CASE WHEN COALESCE (ContainerCountPD_3.Remains, 0) <=  0
                    THEN Null
                    ELSE zfCalc_PriceCash(Price_Unit.PriceSale,
                                         CASE WHEN tmpGoodsSP_FS.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                         COALESCE(GoodsDiscount.GoodsId, 0) <> 0) END :: TFloat  AS Price_unit_3
             , CASE WHEN COALESCE (ContainerCountPD_3.Remains, 0) <=  0
                    THEN Null
                    WHEN COALESCE (RemainsDiscount.GoodsId, 0) <> 0 AND COALESCE(Price_Unit.Price, 0) > 0 AND 
                         COALESCE (GoodsDiscount.DiscountProcent, 0) > 0 AND GoodsDiscount.isDiscountSite = TRUE
                    THEN ROUND(CASE WHEN COALESCE(GoodsDiscount.MaxPrice, 0) = 0 OR Price_Unit.Price < GoodsDiscount.MaxPrice
                                    THEN Price_Unit.Price ELSE GoodsDiscount.MaxPrice END * (100 - GoodsDiscount.DiscountProcent) / 100, 1)
                    WHEN Price_Unit.isTop = TRUE
                    THEN zfCalc_PriceCash(CASE WHEN tmpList.GoodsId_retail = tmpList.GoodsId
                                               THEN Price_Unit.Price --COALESCE (tmpPrice_Site.Price, Price_Unit.Price)
                                               ELSE Price_Unit.Price END,
                                               CASE WHEN tmpGoodsSP_FS.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                               COALESCE(GoodsDiscount.GoodsId, 0) <> 0)
                    WHEN COALESCE(tmpPromoBonus.BonusInetOrder, 0) <> 0
                     AND Object_Goods_Retail.IsTop = False 
                     AND (COALESCE(Price_Unit.PriceChange, 0) = 0 AND
                          COALESCE(Price_Unit.FixPercent, 0) = 0 AND
                          COALESCE(Price_Unit.FixDiscount, 0) = 0 OR
                          COALESCE(Price_Unit.Multiplicity, 0) > 1)
                     AND COALESCE ( ContainerCountPD_3.PricePartionDate, 0) > 0
                     AND COALESCE ( ContainerCountPD_3.PricePartionDate, 0) > 
                          zfCalc_PriceCash(Round(Price_Unit.Price * 100.0 / (100.0 + tmpPromoBonus.MarginPercent) * 
                                          (100.0 - tmpPromoBonus.BonusInetOrder + tmpPromoBonus.MarginPercent) / 100, 2), 
                                          CASE WHEN tmpGoodsSP_FS.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                               COALESCE(GoodsDiscount.GoodsId, 0) <> 0)
                    THEN zfCalc_PriceCash(Round(Price_Unit.Price * 100.0 / (100.0 + tmpPromoBonus.MarginPercent) * 
                                          (100.0 - tmpPromoBonus.BonusInetOrder + tmpPromoBonus.MarginPercent) / 100, 2), 
                                          CASE WHEN tmpGoodsSP_FS.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                               COALESCE(GoodsDiscount.GoodsId, 0) <> 0)
                    ELSE ContainerCountPD_3.PricePartionDate
                    END                                  :: TFloat AS  Price_unit_sale_3

             , ContainerCountPD_6.PartionDateKindId    AS PartionDateKindId_6
             , ContainerCountPD_6.Remains::TFloat AS Remains_6
             , CASE WHEN COALESCE (ContainerCountPD_6.Remains, 0) <=  0
                    THEN Null
                    ELSE zfCalc_PriceCash(Price_Unit.PriceSale,
                                          CASE WHEN tmpGoodsSP_FS.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                          COALESCE(GoodsDiscount.GoodsId, 0) <> 0) END :: TFloat  AS  Price_unit_6
             , CASE WHEN COALESCE (ContainerCountPD_6.Remains, 0) <=  0
                    THEN Null
                    WHEN COALESCE (RemainsDiscount.GoodsId, 0) <> 0 AND COALESCE(Price_Unit.Price, 0) > 0 AND 
                         COALESCE (GoodsDiscount.DiscountProcent, 0) > 0 AND GoodsDiscount.isDiscountSite = TRUE
                    THEN ROUND(CASE WHEN COALESCE(GoodsDiscount.MaxPrice, 0) = 0 OR Price_Unit.Price < GoodsDiscount.MaxPrice
                                    THEN Price_Unit.Price ELSE GoodsDiscount.MaxPrice END * (100 - GoodsDiscount.DiscountProcent) / 100, 1)
                    WHEN Price_Unit.isTop = TRUE
                    THEN zfCalc_PriceCash(CASE WHEN tmpList.GoodsId_retail = tmpList.GoodsId
                                               THEN Price_Unit.Price -- COALESCE (tmpPrice_Site.Price, Price_Unit.Price)
                                               ELSE Price_Unit.Price END,
                                               CASE WHEN tmpGoodsSP_FS.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                               COALESCE(GoodsDiscount.GoodsId, 0) <> 0)
                    WHEN COALESCE(tmpPromoBonus.BonusInetOrder, 0) <> 0
                     AND Object_Goods_Retail.IsTop = False 
                     AND (COALESCE(Price_Unit.PriceChange, 0) = 0 AND
                          COALESCE(Price_Unit.FixPercent, 0) = 0 AND
                          COALESCE(Price_Unit.FixDiscount, 0) = 0 OR
                          COALESCE(Price_Unit.Multiplicity, 0) > 1)
                     AND COALESCE ( ContainerCountPD_6.PricePartionDate, 0) > 0
                     AND COALESCE ( ContainerCountPD_6.PricePartionDate, 0) > 
                          zfCalc_PriceCash(Round(Price_Unit.Price * 100.0 / (100.0 + tmpPromoBonus.MarginPercent) * 
                                          (100.0 - tmpPromoBonus.BonusInetOrder + tmpPromoBonus.MarginPercent) / 100, 2), 
                                          CASE WHEN tmpGoodsSP_FS.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                               COALESCE(GoodsDiscount.GoodsId, 0) <> 0)
                    THEN zfCalc_PriceCash(Round(Price_Unit.Price * 100.0 / (100.0 + tmpPromoBonus.MarginPercent) * 
                                          (100.0 - tmpPromoBonus.BonusInetOrder + tmpPromoBonus.MarginPercent) / 100, 2), 
                                          CASE WHEN tmpGoodsSP_FS.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                               COALESCE(GoodsDiscount.GoodsId, 0) <> 0)
                    ELSE ContainerCountPD_6.PricePartionDate
                    END                                  :: TFloat AS  Price_unit_sale_6


             , COALESCE(tmpList.Multiplicity, 0) :: TFloat AS Multiplicity

        FROM _tmpList AS tmpList 

             LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id  = tmpList.GoodsId_retail
             LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

             LEFT JOIN tmpMI_Deferred ON tmpMI_Deferred.GoodsId = tmpList.GoodsId_retail
                                     AND tmpMI_Deferred.UnitId  = tmpList.UnitId

             LEFT OUTER JOIN tmpMovementTP AS Reserve_TP ON Reserve_TP.GoodsId = tmpList.GoodsId_retail
                                                        AND Reserve_TP.UnitId = tmpList.UnitId

             LEFT JOIN Price_Unit_All AS price_unit
                                      ON Price_Unit.GoodsId     = tmpList.GoodsId
                                     AND Price_Unit.UnitId      = tmpList.UnitId
                                     
             --LEFT JOIN tmpPrice_Site  ON tmpPrice_Site.GoodsId  = tmpList.GoodsId
                          
             LEFT JOIN _tmpContainerCount AS tmpList2
                                          ON tmpList2.GoodsId = tmpList.GoodsId
                                         AND tmpList2.UnitId  = tmpList.UnitId
             LEFT JOIN _tmpMinPrice_List AS MinPrice_List  ON MinPrice_List.GoodsId  = tmpList.GoodsId
                                                          AND MinPrice_List.AreaId   =
                                                              CASE WHEN tmpList.AreaId <> 12487449  THEN tmpList.AreaId ELSE zc_Area_Basis() END
             LEFT JOIN _tmpMinPrice_List AS MinPrice_List_D  ON MinPrice_List_D.GoodsId  = tmpList.GoodsId
                                                            AND MinPrice_List_D.AreaId   =
                                                                CASE WHEN tmpList.AreaId <> 12487449 THEN tmpList.AreaId ELSE zc_Area_Basis() END

             LEFT JOIN Object AS Object_Goods    ON Object_Goods.Id    = tmpList.GoodsId
             LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MinPrice_List.ContractId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                  ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
             LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                  ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId

             LEFT JOIN MarginCategory      ON MinPrice_List.Price >= MarginCategory.MinPrice      AND MinPrice_List.Price < MarginCategory.MaxPrice
                                          AND MarginCategory.UnitId = tmpList.UnitId
             LEFT JOIN MarginCategory_site ON MinPrice_List.Price >= MarginCategory_site.MinPrice AND MinPrice_List.Price < MarginCategory_site.MaxPrice

             LEFT JOIN tmpPDGoodsRemains AS PDGoodsRemains
                                         ON PDGoodsRemains.GoodsId = tmpList.GoodsId_retail
                                        AND PDGoodsRemains.UnitId = tmpList.UnitId

             -- ��� ���� �����
             LEFT JOIN tmpPromoBonus ON tmpPromoBonus.GoodsId = tmpList.GoodsId
                                    AND tmpPromoBonus.UnitId = tmpList.UnitId 

             LEFT JOIN _tmpContainerCountPD AS ContainerCountPD_1
                                            ON ContainerCountPD_1.PartionDateKindId = zc_Enum_PartionDateKind_1()
                                           AND ContainerCountPD_1.GoodsId = tmpList.GoodsId_retail
                                           AND ContainerCountPD_1.UnitId = tmpList.UnitId 

             LEFT JOIN _tmpContainerCountPD AS ContainerCountPD_3
                                            ON ContainerCountPD_3.PartionDateKindId = zc_Enum_PartionDateKind_3()
                                           AND ContainerCountPD_3.GoodsId = tmpList.GoodsId_retail
                                           AND ContainerCountPD_3.UnitId = tmpList.UnitId 

             LEFT JOIN _tmpContainerCountPD AS ContainerCountPD_6
                                            ON ContainerCountPD_6.PartionDateKindId = zc_Enum_PartionDateKind_6()
                                           AND ContainerCountPD_6.GoodsId = tmpList.GoodsId_retail
                                           AND ContainerCountPD_6.UnitId = tmpList.UnitId 
                                           
             LEFT JOIN tmpGoodsDiscount AS GoodsDiscount
                                        ON GoodsDiscount.GoodsId = tmpList.GoodsId
                                       AND GoodsDiscount.UnitId = tmpList.UnitId
                                       
             LEFT JOIN tmpRemainsDiscount AS RemainsDiscount
                                          ON RemainsDiscount.GoodsId = tmpList.GoodsId
                                         AND RemainsDiscount.UnitId = tmpList.UnitId

             -- ��� ������
             LEFT JOIN tmpGoodsSP_FS ON tmpGoodsSP_FS.GoodsId = tmpList.GoodsId
                                 AND tmpGoodsSP_FS.Ord     = 1 -- � �/� - �� ������ ������
                                 
                                        
        ORDER BY Price_Unit.Price
       ;
       
--raise notice 'Value 20: %', CLOCK_TIMESTAMP();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 30.01.19                                                                    *
 19.04.16                                        *
*/

-- ����

SELECT OBJECT_Unit.valuedata, OBJECT_Goods.valuedata, p.* FROM gpselect_goodsonunit_forsite ('16240371,8156016,377610,11769526,183292,4135547,14422124,14422095,377606,6128298,13338606,377595,377605,494882,10779386,183289,8393158,6309262,13311246,377613,377594,377574,15212291,13711869,1781716,5120968,9771036,6608396,375626,375627,11152911,10128935,472116,15171089', 
                                                                                             '18200689', TRUE, zfCalc_UserSite()) AS p
 LEFT JOIN OBJECT AS OBJECT_Unit ON OBJECT_Unit.ID = p.UnitId
 LEFT JOIN OBJECT AS OBJECT_Goods ON OBJECT_Goods.ID = p.Id
ORDER BY OBJECT_Unit.valuedata, OBJECT_Goods.valuedata
 
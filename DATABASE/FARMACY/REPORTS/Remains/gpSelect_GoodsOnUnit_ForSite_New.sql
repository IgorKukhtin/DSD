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

             , Price_unit        TFloat -- ���� ������
             , Price_unit_sale   TFloat -- ���� ������ �� �������
             , Price_min         TFloat -- ���� ����� ���������� � ��� � ��������
             , Price_min_sale    TFloat -- ���� ����� ���������� � ��� � �������� �� �������
             , Price_minD        TFloat -- Delivery - ���� ����� � ��� � �������� - ��������

             , JuridicalId       Integer    -- ��������� (�� �������� ������� ����� ����)
             , JuridicalName     TVarChar   -- ��������� (�� �������� ������� ����� ����)
             , ContractId        Integer    -- ������� (�� �������� ������� ����� ����)
             , ContractName      TVarChar   -- ������� (�� �������� ������� ����� ����)
             , ExpirationDate    TDateTime -- ���� �������� (�� �������� ������� ����� ����)

             , Remains_1         TFloat   -- ������� �� ������ (� ������ �������)
             , Price_unit_1      TFloat   -- ���� ������
             , Price_unit_sale_1 TFloat   -- ���� ������ �� �������

             , Remains_6         TFloat    -- ������� ����� ������ �� 6 (� ������ �������)
             , Price_unit_6      TFloat    -- ���� ������
             , Price_unit_sale_6 TFloat    -- ���� ������ �� �������
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;

   -- DECLARE inUnitId Integer;

   DECLARE vbIndex Integer;
   -- DECLARE vbMarginCategoryId Integer;
   DECLARE vbMarginCategoryId_site Integer;

   DECLARE vbOperDate_Begin1 TDateTime;
   DECLARE vbOperDate_Begin2 TDateTime;
   DECLARE vbOperDate_Begin3 TDateTime;
   DECLARE vbOperDate_Begin4 TDateTime;
   DECLARE vbSiteDiscount TFloat;
   DECLARE vbQueryText Text;

   DECLARE vbDate0    TDateTime;
   DECLARE vbDate180  TDateTime;
   DECLARE vbDate30   TDateTime;

   DECLARE vbMonth_0   TFloat;
   DECLARE vbMonth_1   TFloat;
   DECLARE vbMonth_6   TFloat;
   DECLARE vbIsMonth_0 Boolean;
   DECLARE vbIsMonth_1 Boolean;
   DECLARE vbIsMonth_6 Boolean;
BEGIN
     -- ����� ��������� ����� ������ ���������� ����.
     vbOperDate_Begin1:= CLOCK_TIMESTAMP();

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

    -- ������������ <�������� ����>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', ABS (vbUserId));
    vbSiteDiscount := COALESCE (gpGet_GlobalConst_SiteDiscount(inSession), 0);

    -- �������� �������� �� �����������
    SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END
         , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END
           INTO vbMonth_0, vbIsMonth_0
    FROM Object  AS Object_PartionDateKind
         LEFT JOIN ObjectFloat AS ObjectFloat_Month
                               ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                              AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
         LEFT JOIN ObjectFloat AS ObjectFloat_Day
                               ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                              AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
    WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_0();
    --
    SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END
         , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END
           INTO vbMonth_1, vbIsMonth_1
    FROM Object  AS Object_PartionDateKind
         LEFT JOIN ObjectFloat AS ObjectFloat_Month
                               ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                              AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
         LEFT JOIN ObjectFloat AS ObjectFloat_Day
                               ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                              AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
    WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_1();
    --
    SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END
         , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END
           INTO vbMonth_6, vbIsMonth_6
    FROM Object  AS Object_PartionDateKind
         LEFT JOIN ObjectFloat AS ObjectFloat_Month
                               ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                              AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
         LEFT JOIN ObjectFloat AS ObjectFloat_Day
                               ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                              AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
    WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6();

    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpgoodsminprice_list')
    THEN
        -- �������
        CREATE TEMP TABLE _tmpGoodsMinPrice_List (GoodsId Integer, GoodsId_retail Integer) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpGoodsMinPrice_List;
    END IF;
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpunitminprice_list')
    THEN
        -- �������
        CREATE TEMP TABLE _tmpUnitMinPrice_List (UnitId Integer, AreaId Integer) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpUnitMinPrice_List;
    END IF;

    -- ���� + 6 �������, + 1 �����
    vbDate180 := CURRENT_DATE + CASE WHEN vbIsMonth_6 = TRUE THEN vbMonth_6 ||' MONTH'  ELSE vbMonth_6 ||' DAY' END :: INTERVAL;
    vbDate30  := CURRENT_DATE + CASE WHEN vbIsMonth_1 = TRUE THEN vbMonth_1 ||' MONTH'  ELSE vbMonth_1 ||' DAY' END :: INTERVAL;
    vbDate0   := CURRENT_DATE + CASE WHEN vbIsMonth_0 = TRUE THEN vbMonth_0 ||' MONTH'  ELSE vbMonth_0 ||' DAY' END :: INTERVAL;

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

    -- !!!��������!!!
    -- inUnitId:= (SELECT tmpList.UnitId FROM _tmpUnitMinPrice_List LIMIT 1);

    -- !!!��������!!!
    -- INSERT INTO _tmpUnitMinPrice_List (UnitId) SELECT 0 WHERE NOT EXISTS (SELECT 1 FROM _tmpUnitMinPrice_List);

    -- ������ ������
    IF COALESCE(inGoodsId_list, '') <> ''
    THEN
      vbQueryText := 'INSERT INTO _tmpGoodsMinPrice_List (GoodsId, GoodsId_retail)
                      SELECT  Retail4.Id, RetailAll.Id
                      FROM Object_Goods_Retail AS Retail4
                           INNER JOIN Object_Goods_Retail AS RetailAll ON RetailAll.GoodsMainId  = Retail4.GoodsMainId
                      WHERE Retail4.Id IN ('||inGoodsId_list||')';

      EXECUTE vbQueryText;
    END IF;

    -- !!!�����������!!!
    ANALYZE _tmpUnitMinPrice_List;

    -- ���� ��� �������
    IF NOT EXISTS (SELECT 1 FROM _tmpGoodsMinPrice_List WHERE GoodsId <> 0)
    THEN
         -- ��� �������
         INSERT INTO _tmpGoodsMinPrice_List (GoodsId, GoodsId_retail)
           -- SELECT DISTINCT Container.ObjectId -- ����� ����� "����"
           -- !!!�������� �����������, ����� ������ ����� �������!!!!
           SELECT DISTINCT
                  ObjectLink_Child_NB.ChildObjectId AS ObjectID -- ����� ����� "����"
                , Container.ObjectId
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
          ;
    END IF;

    -- !!!�����������!!!
    ANALYZE _tmpGoodsMinPrice_List;

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

    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpMovementCheck'))
    THEN
        -- �������
        CREATE TEMP TABLE _tmpMovementCheck (Id Integer) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpMovementCheck;
    END IF;
    --
    INSERT INTO _tmpMovementCheck (Id)
      WITH           -- ������� �� ������
            tmpMovementCheck AS (SELECT Movement.Id
                                 FROM Movement
                                 WHERE Movement.DescId = zc_Movement_Check()
                                   AND Movement.StatusId = zc_Enum_Status_UnComplete())
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

    SELECT Movement.Id FROM tmpMovReserveAll AS Movement;

    -- ��� ������������ - _tmpContainerCountPD
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpContainerCountPD'))
    THEN
        -- �������
        CREATE TEMP TABLE _tmpContainerCountPD (UnitId Integer, GoodsId Integer, PartionDateKindId Integer, Amount TFloat, Remains TFloat, PriceWithVAT TFloat, PartionDateDiscount TFloat, Price TFloat) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpContainerCountPD;
    END IF;
    --
    INSERT INTO _tmpContainerCountPD (UnitId, GoodsId, PartionDateKindId, Amount, Remains, PriceWithVAT, PartionDateDiscount)
      WITH           -- ������� �� ������
             MovementItemChildId AS (SELECT MovementItemChild.Id
                                          , MovementItemChild.Amount
                                     FROM _tmpMovementCheck AS Movement

                                          INNER JOIN MovementItem AS MovementItemChild
                                                                  ON MovementItemChild.MovementId = Movement.Id
                                                                 AND MovementItemChild.DescId     = zc_MI_Child()
                                                                 AND MovementItemChild.Amount     > 0
                                                                 AND MovementItemChild.isErased   = FALSE)
          , ReserveContainer AS (SELECT MIFloat_ContainerId.ValueData::Integer      AS ContainerId
                                      , Sum(MovementItemChildId.Amount)::TFloat       AS Amount
                                 FROM MovementItemChildId
                                 INNER JOIN MovementItemFloat AS MIFloat_ContainerId
                                                                  ON MIFloat_ContainerId.MovementItemId = MovementItemChildId.Id
                                                                 AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

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
                                         ReserveContainer.Amount                                 AS Reserve
                                  FROM _tmpGoodsMinPrice_List

                                       INNER JOIN Container ON Container.ObjectId = _tmpGoodsMinPrice_List.GoodsId_retail
                                                           AND Container.DescId = zc_Container_CountPartionDate()
                                                           AND Container.WhereObjectId IN (SELECT _tmpUnitMinPrice_List.UnitId FROM _tmpUnitMinPrice_List)

                                       LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                       LEFT OUTER JOIN ReserveContainer ON ReserveContainer.ContainerID = Container.Id
                                  WHERE (Container.Amount - COALESCE(ReserveContainer.Amount, 0)) > 0)
          , tmpPDContainer AS (SELECT Container.Id,
                                      Container.WhereObjectId,
                                      Container.ObjectId,
                                      Container.Amount,
                                      Container.Remains,
                                      COALESCE (ObjectFloat_PartionGoods_ValueMin.ValueData, 0)     AS PercentMin,
                                      COALESCE (ObjectFloat_PartionGoods_Value.ValueData, 0)        AS Percent,
                                      COALESCE (ObjectFloat_PartionGoods_PriceWithVAT.ValueData, 0) AS PriceWithVAT,
                                      CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate0   THEN zc_Enum_PartionDateKind_0()  -- ����������
                                           WHEN ObjectDate_ExpirationDate.ValueData <= vbDate30  THEN zc_Enum_PartionDateKind_1()  -- ������ 1 ������
                                           WHEN ObjectDate_ExpirationDate.ValueData <= vbDate180 THEN zc_Enum_PartionDateKind_6()  -- ������ 6 ������
                                           ELSE zc_Enum_PartionDateKind_Good() END                  AS PartionDateKindId           -- ����������� � ���������
                               FROM tmpPDContainerAll AS Container

                                    LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                         ON ObjectDate_ExpirationDate.ObjectId = Container.PartionGoodsId
                                                        AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                                    LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_ValueMin
                                                          ON ObjectFloat_PartionGoods_ValueMin.ObjectId =  Container.PartionGoodsId
                                                         AND ObjectFloat_PartionGoods_ValueMin.DescId = zc_ObjectFloat_PartionGoods_ValueMin()

                                    LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_Value
                                                          ON ObjectFloat_PartionGoods_Value.ObjectId =  Container.PartionGoodsId
                                                         AND ObjectFloat_PartionGoods_Value.DescId = zc_ObjectFloat_PartionGoods_Value()

                                    LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_PriceWithVAT
                                                          ON ObjectFloat_PartionGoods_PriceWithVAT.ObjectId =  Container.PartionGoodsId
                                                         AND ObjectFloat_PartionGoods_PriceWithVAT.DescId = zc_ObjectFloat_PartionGoods_PriceWithVAT()
                                )
        SELECT Container.WhereObjectId
             , Container.ObjectId
             , Container.PartionDateKindId                                                  AS PartionDateKindId
             , SUM (Container.Amount)                                                       AS Amount
             , SUM (Container.Remains)                                                      AS Remains
             , Max(Container.PriceWithVAT)                                                  AS PriceWithVAT
             , MIN (CASE WHEN Container.PartionDateKindId = zc_Enum_PartionDateKind_Good()
                         THEN 0
                         WHEN Container.PartionDateKindId = zc_Enum_PartionDateKind_6()
                         THEN Container.Percent
                         ELSE Container.PercentMin END)::TFloat                             AS PartionDateDiscount
        FROM tmpPDContainer AS Container
        GROUP BY Container.WhereObjectId
               , Container.ObjectId
               , Container.PartionDateKindId;

    -- !!!�����������!!!
    ANALYZE _tmpContainerCountPD;

    -- ��� ������������ - _tmpList
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpList'))
    THEN
        -- �������
        CREATE TEMP TABLE _tmpList (UnitId Integer, AreaId Integer, GoodsId Integer, GoodsId_retail Integer) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpList;
    END IF;
    --
    INSERT INTO _tmpList (UnitId, AreaId, GoodsId, GoodsId_retail)

                SELECT DISTINCT
                       _tmpUnitMinPrice_List.UnitId
                     , _tmpUnitMinPrice_List.AreaId
                     , _tmpGoodsMinPrice_List.GoodsId
                     , _tmpGoodsMinPrice_List.GoodsId_retail
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
    INSERT INTO _tmpList (UnitId, AreaId, GoodsId, GoodsId_retail)
                SELECT DISTINCT
                       _tmpUnitMinPrice_List.UnitId
                     , _tmpUnitMinPrice_List.AreaId
                     , _tmpGoodsMinPrice_List.GoodsId
                     , _tmpGoodsMinPrice_List.GoodsId AS GoodsId_retail
                FROM _tmpGoodsMinPrice_List
                     CROSS JOIN _tmpUnitMinPrice_List -- ON 1=1
                     LEFT JOIN _tmpList ON _tmpList.UnitId = _tmpUnitMinPrice_List.UnitId
                                       AND _tmpList.GoodsId = _tmpGoodsMinPrice_List.GoodsId
                WHERE _tmpList.GoodsId IS NULL;

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
    vbOperDate_Begin2:= CLOCK_TIMESTAMP();

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
             )

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
                                           ON GoodsList_all.GoodsId = MinPriceList.GoodsId;

    -- ��������� ����� ����� lpSelectMinPrice_List
    vbOperDate_Begin3:= CLOCK_TIMESTAMP();


    -- ����� ��������� ��� �����
    vbMarginCategoryId_site:= (SELECT ObjectBoolean.ObjectId
                               FROM ObjectBoolean
                               WHERE ObjectBoolean.ValueData = TRUE
                                 AND ObjectBoolean.DescId = zc_ObjectBoolean_MarginCategory_Site()
                               LIMIT 1
                              );


    -- !!!�����������!!!
    ANALYZE _tmpList;
    -- !!!�����������!!!
    ANALYZE _tmpMinPrice_List;

    -- ���������
    RETURN QUERY
       WITH tmpMI_Deferred AS
               (SELECT MovementLinkObject_Unit.ObjectId AS UnitId
                     , MovementItem.ObjectId     AS GoodsId
                     , SUM (MovementItem.Amount) AS Amount
                FROM _tmpMovementCheck AS Movement

                     INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                   ON MovementLinkObject_Unit.movementid = Movement.Id
                                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.isErased   = FALSE

                GROUP BY MovementLinkObject_Unit.ObjectId
                       , MovementItem.ObjectId
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
          , Price_Unit_all AS
               (SELECT _tmpList.UnitId
                     , _tmpList.GoodsId
                     , CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                             AND ObjectFloat_Goods_Price.ValueData > 0
                                 THEN ObjectFloat_Goods_Price.ValueData
                            ELSE ObjectFloat_Price_Value.ValueData
                       END AS Price
                -- FROM _tmpGoodsMinPrice_List
                FROM _tmpList
                     INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                           ON ObjectLink_Price_Goods.ChildObjectId = _tmpList.GoodsId_retail -- _tmpGoodsMinPrice_List.GoodsId
                                          AND ObjectLink_Price_Goods.DescId        = zc_ObjectLink_Price_Goods()
                     INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                           ON ObjectLink_Price_Unit.ObjectId      = ObjectLink_Price_Goods.ObjectId
                                          AND ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                          AND ObjectLink_Price_Unit.ChildObjectId = _tmpList.UnitId
                     -- INNER JOIN _tmpUnitMinPrice_List AS tmpList ON tmpList.UnitId = ObjectLink_Price_Unit.ChildObjectId
                     LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                           ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Price_Goods.ObjectId
                                          AND ObjectFloat_Price_Value.DescId = zc_ObjectFloat_Price_Value()
                     -- ���� ���� ��� ���� ����
                     LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                            ON ObjectFloat_Goods_Price.ObjectId = ObjectLink_Price_Goods.ChildObjectId
                                           AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                     LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                             ON ObjectBoolean_Goods_TOP.ObjectId = ObjectLink_Price_Goods.ChildObjectId
                                            AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
               )
          , Price_Unit AS
               (SELECT Price_Unit_all.UnitId
                     , Price_Unit_all.GoodsId
                     , Price_Unit_all.Price
                FROM Price_Unit_all
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

        SELECT Object_Goods.Id                                                     AS Id

             , CASE WHEN Object_Goods.isErased = TRUE THEN 1 ELSE 0 END::Integer   AS deleted

             , tmpList.UnitId                                                      AS UnitId
             , (tmpList2.Amount - COALESCE (tmpMI_Deferred.Amount, 0) -
                                  COALESCE (PDGoodsRemains.Amount, 0))::TFloat     AS Remains

             , Price_Unit.Price    AS Price_unit
             , ROUND (CASE WHEN vbSiteDiscount = 0 THEN Price_Unit.Price
                        ELSE CEIL(Price_Unit.Price * (100.0 - vbSiteDiscount) / 10.0) / 10.0 END, 2) :: TFloat AS Price_unit_sale
             , ROUND (MinPrice_List.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100) * (1 + COALESCE (MarginCategory.MarginPercent, 0)      / 100), 2) :: TFloat  AS Price_min
             , ROUND (CASE WHEN vbSiteDiscount = 0 THEN ROUND (MinPrice_List.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100) * (1 + COALESCE (MarginCategory.MarginPercent, 0) / 100), 2)
                        ELSE CEIL(ROUND (MinPrice_List.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100) * (1 + COALESCE (MarginCategory.MarginPercent, 0) / 100), 2) *
                        (100.0 - vbSiteDiscount) / 10.0) / 10.0 END, 2) :: TFloat AS Price_min_sale
             , ROUND (MinPrice_List_D.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100) * (1 + COALESCE (MarginCategory_site.MarginPercent, 0) / 100), 2) :: TFloat  AS Price_minD

             , MinPrice_List.JuridicalId
             , MinPrice_List.JuridicalName
             , MinPrice_List.ContractId
             , Object_Contract.ValueData       AS ContractName
             , MinPrice_List.PartionGoodsDate  AS ExpirationDate

             , PDGoodsRemains1.Remains::TFloat AS Remains_1
             , (CEIL(Price_Unit.Price * (100.0 - PDGoodsRemains1.PartionDateDiscount) / 100 * 10.0) / 10.0)::TFloat AS Price_unit_1
             , ROUND (CASE WHEN vbSiteDiscount = 0 THEN CEIL(Price_Unit.Price * (100.0 - PDGoodsRemains1.PartionDateDiscount) / 100 * 10.0) / 10.0
                      ELSE CEIL(CEIL(Price_Unit.Price * (100.0 - PDGoodsRemains1.PartionDateDiscount) / 100 * 10.0) / 10.0 * (100.0 - vbSiteDiscount) / 10.0) / 10.0 END, 2)::TFloat AS Price_unit_sale_1

             , PDGoodsRemains6.Remains::TFloat AS Remains_6
             , CASE WHEN PDGoodsRemains6.Remains IS NULL THEN NULL
                     ELSE CEIL(CASE WHEN Price_Unit.Price > CASE WHEN PDGoodsRemains6.PriceWithVAT > 14 AND COALESCE (MinPrice_List.Price, 0) = 0 THEN PDGoodsRemains6.PriceWithVAT ELSE 
                                    ROUND (MinPrice_List.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100), 2) END
                               THEN ROUND(Price_Unit.Price - (Price_Unit.Price - CASE WHEN PDGoodsRemains6.PriceWithVAT > 14 AND COALESCE (MinPrice_List.Price, 0) = 0 THEN PDGoodsRemains6.PriceWithVAT ELSE 
                                    ROUND (MinPrice_List.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100), 2) END) * PDGoodsRemains6.PartionDateDiscount / 100, 2)
                               ELSE Price_Unit.Price END * 10.0) / 10.0 END::TFloat                AS Price_unit_6
             , CASE WHEN PDGoodsRemains6.Remains IS NULL THEN NULL
                     ELSE ROUND (CASE WHEN vbSiteDiscount = 0 THEN
                 CEIL(CASE WHEN Price_Unit.Price > CASE WHEN PDGoodsRemains6.PriceWithVAT > 14 AND COALESCE (MinPrice_List.Price, 0) = 0 THEN PDGoodsRemains6.PriceWithVAT ELSE 
                                    ROUND (MinPrice_List.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100), 2) END
                     THEN ROUND(Price_Unit.Price - (Price_Unit.Price - CASE WHEN PDGoodsRemains6.PriceWithVAT > 14 AND COALESCE (MinPrice_List.Price, 0) = 0 THEN PDGoodsRemains6.PriceWithVAT ELSE 
                                    ROUND (MinPrice_List.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100), 2) END) * PDGoodsRemains6.PartionDateDiscount / 100, 2)
                     ELSE Price_Unit.Price END * 10.0) / 10.0
                  ELSE CEIL(CEIL(CASE WHEN Price_Unit.Price > CASE WHEN PDGoodsRemains6.PriceWithVAT > 14 AND COALESCE (MinPrice_List.Price, 0) = 0 THEN PDGoodsRemains6.PriceWithVAT ELSE 
                                    ROUND (MinPrice_List.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100), 2) END
                     THEN ROUND(Price_Unit.Price - CASE WHEN PDGoodsRemains6.PriceWithVAT > 14 AND COALESCE (MinPrice_List.Price, 0) = 0 THEN PDGoodsRemains6.PriceWithVAT ELSE 
                                    ROUND (MinPrice_List.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100), 2) END * PDGoodsRemains6.PartionDateDiscount / 100, 2)
                     ELSE Price_Unit.Price END * 10.0) / 10.0 * (100.0 - vbSiteDiscount) / 10.0) / 10.0 END, 2) END :: TFloat AS Price_unit_sale_6

        FROM _tmpList AS tmpList -- _tmpContainerCount AS tmpList -- _tmpList AS tmpList -- _tmpGoodsMinPrice_List
             -- LEFT JOIN _tmpUnitMinPrice_List ON 1=1

             LEFT JOIN tmpMI_Deferred ON tmpMI_Deferred.GoodsId = tmpList.GoodsId_retail
                                     AND tmpMI_Deferred.UnitId  = tmpList.UnitId

             LEFT JOIN Price_Unit     ON Price_Unit.GoodsId     = tmpList.GoodsId
                                     AND Price_Unit.UnitId      = tmpList.UnitId
             LEFT JOIN _tmpContainerCount AS tmpList2
                                          ON tmpList2.GoodsId = tmpList.GoodsId
                                         AND tmpList2.UnitId  = tmpList.UnitId
             LEFT JOIN _tmpMinPrice_List AS MinPrice_List  ON MinPrice_List.GoodsId  = tmpList.GoodsId
                                                          AND MinPrice_List.AreaId   = 
                                                              CASE WHEN tmpList.AreaId <> 12487449  THEN tmpList.AreaId ELSE zc_Area_Basis() END
             LEFT JOIN _tmpMinPrice_List AS MinPrice_List_D  ON MinPrice_List_D.GoodsId  = tmpList.GoodsId
                                                            AND MinPrice_List_D.AreaId   = 
                                                                CASE WHEN tmpList.AreaId <> 12487449 AND tmpList.AreaId = 5959000 THEN tmpList.AreaId ELSE zc_Area_Basis() END

             LEFT JOIN Object AS Object_Goods    ON Object_Goods.Id    = tmpList.GoodsId
             LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MinPrice_List.ContractId


             LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                  ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
             LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId
             LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                  ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId


             LEFT JOIN MarginCategory      ON MinPrice_List.Price >= MarginCategory.MinPrice      AND MinPrice_List.Price < MarginCategory.MaxPrice
                                          AND MarginCategory.UnitId = tmpList.UnitId
             LEFT JOIN MarginCategory_site ON MinPrice_List.Price >= MarginCategory_site.MinPrice AND MinPrice_List.Price < MarginCategory_site.MaxPrice
             LEFT JOIN Object AS Object_MarginCategory      ON Object_MarginCategory.Id      = MarginCategory.MarginCategoryId
             LEFT JOIN Object AS Object_MarginCategory_site ON Object_MarginCategory_site.Id = vbMarginCategoryId_site

             LEFT JOIN tmpPDGoodsRemains AS PDGoodsRemains
                                         ON PDGoodsRemains.GoodsId = tmpList.GoodsId_retail
                                        AND PDGoodsRemains.UnitId = tmpList.UnitId

             LEFT JOIN _tmpContainerCountPD AS PDGoodsRemains1
                                            ON PDGoodsRemains1.GoodsId = tmpList.GoodsId_retail
                                           AND PDGoodsRemains1.UnitId = tmpList.UnitId
                                           AND PDGoodsRemains1.PartionDateKindId = zc_Enum_PartionDateKind_1()

             LEFT JOIN _tmpContainerCountPD AS PDGoodsRemains6
                                            ON PDGoodsRemains6.GoodsId = tmpList.GoodsId_retail
                                           AND PDGoodsRemains6.UnitId = tmpList.UnitId
                                           AND PDGoodsRemains6.PartionDateKindId = zc_Enum_PartionDateKind_6()
        ORDER BY Price_Unit.Price
       ;

     -- !!!�������� - �������� - �����������!!!
     INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        WITH tmp_pg AS (SELECT * FROM pg_stat_activity WHERE state = 'active')
        SELECT vbUserId
               -- �� ������� ��������
             , CURRENT_TIMESTAMP
             , (SELECT COUNT (*) FROM tmp_pg)                                   AS Value1
             , (SELECT COUNT (*) FROM tmp_pg WHERE client_addr =  '172.17.2.4') AS Value2
             , (SELECT COUNT (*) FROM tmp_pg WHERE client_addr <> '172.17.2.4') AS Value3
             , 0 AS Value4
             , 0 AS Value5
               -- ������� ����� ����������� ����
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time1
               -- ������� ����� ����������� ���� �� lpSelectMinPrice_List
             , (vbOperDate_Begin2 - vbOperDate_Begin1) :: INTERVAL AS Time2
               -- ������� ����� ����������� ���� lpSelectMinPrice_List
             , (vbOperDate_Begin3 - vbOperDate_Begin2) :: INTERVAL AS Time3
               -- ������� ����� ����������� ���� ����� lpSelectMinPrice_List
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin3) :: INTERVAL AS Time4
               -- �� ������� �����������
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpSelect_GoodsOnUnit_ForSite'
               -- ProtocolData
             , CHR (39) || inUnitId_list || CHR (39) || ' , ' || CHR (39) || inGoodsId_list || CHR (39)
        WHERE vbUserId > 0
        ;

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
-- SELECT * FROM ResourseProtocol ORDER BY Id DESC LIMIT 4000
-- SELECT * FROM gpSelect_GoodsOnUnit_ForSite (inUnitId_list:= '1781716', inGoodsId_list:= '47761', inSession:= zfCalc_UserSite()) ORDER BY 1;
--
-- SELECT * FROM gpSelect_GoodsOnUnit_ForSite (inUnitId_list:= '377613,183292', inGoodsId_list:= '331,951,16876,40618', inFrontSite := False, inSession:= zfCalc_UserSite()) ORDER BY 1;
--
--SELECT * FROM gpSelect_GoodsOnUnit_ForSite('183292,183288,377605,375627,394426,472116,494882,1529734,1781716,377606,377595,183290,183289,183294,377613,377574,377594,377610,183293,375626,183291', '508,517,520,526,523,511,544,538,553,559,562,565,571,547,1642,1654,1714,1867,1933,2059,2095,2230,2257,2275,2323,2341,2344,2320,2509,2515', False, zfCalc_UserSite()) AS p ORDER BY p.price_unit

-- SELECT * FROM gpSelect_GoodsOnUnit_ForSite (inUnitId_list:= '377610', inGoodsId_list:= '2149403', inFrontSite := False, inSession:= zfCalc_UserSite());
-- SELECT * FROM gpSelect_GoodsOnUnit_ForSite (inUnitId_list:= '0', inGoodsId_list:= '53275', inFrontSite := True, inSession:= zfCalc_UserSite());

--SELECT p.* FROM gpselect_goodsonunit_forsite ('183292,11769526,4135547,377606,6128298,9951517,13338606,377595,12607257,377605,494882,10779386,394426,183289,8393158,6309262,13311246,377613,7117700,377610,377594,11300059,377574,12812109,183291,1781716,5120968,9771036,8698426,6608396,375626,375627,11152911,10128935,472116', '24970,31333,393553,15610,5878,31561,1849,976003,31285,1594,4534,27658,6430,31000,14941,19093,38173,18922,18916,29449,19696,5486995,28516,26422,21748,15172,3002798,54604,358750,2503', TRUE, zfCalc_UserSite()) AS p
SELECT p.* FROM gpselect_goodsonunit_forsite ('375626,11769526,183292,4135547,377606,6128298,9951517,13338606,377595,12607257,377605,494882,10779386,394426,183289,8393158,6309262,13311246,377613,7117700,377610,377594,11300059,377574,12812109,183291,1781716,5120968,9771036,8698426,6608396,375627,11152911,10128935,472116', '22579,54100,6994,352890,54649,29983,48988,964555,54625,54613,28849,54640,30310,34831,982510,1106785,1243320,2366715,1243457,34867,50134,4509209,22573,50725,1106995,1960400,50152,51202,34846,28858', TRUE, zfCalc_UserSite()) AS p


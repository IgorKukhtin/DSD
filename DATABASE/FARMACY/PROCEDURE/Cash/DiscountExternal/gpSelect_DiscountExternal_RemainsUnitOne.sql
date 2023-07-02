-- Function: gpSelect_DiscountExternal_RemainsUnitOne()

DROP FUNCTION IF EXISTS gpSelect_DiscountExternal_RemainsUnitOne(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_DiscountExternal_RemainsUnitOne(
    IN inDiscountExternalId  Integer    , --
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS TABLE (GoodsId             Integer,    -- �����
               PartionDateKindId   Integer,    -- ���� ����/�� ����
               NDSKindId           Integer,    -- ������ ���
               DiscountExternalID  Integer,    -- ����� ��� ������� (���������� �����)
               DivisionPartiesID   Integer,    -- ���������� ������ � ����� ��� �������
               Price               TFloat,     -- ����
               Remains             TFloat,     -- �������
               RemainsDiscount     TFloat,     -- ������� ��� ���������
               Reserved            TFloat,     -- � �������
               DeferredSend        TFloat,     -- � ���������� ������������
               DeferredTR          TFloat      -- � ���������� ����������� ����������
               ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbObjectId Integer;
   DECLARE vbRetailId Integer;
   DECLARE vbAreaId   Integer;

   DECLARE vbDate_6 TDateTime;
   DECLARE vbDate_3 TDateTime;
   DECLARE vbDate_1 TDateTime;
   DECLARE vbDate_0 TDateTime;

   DECLARE vbDividePartionDate   boolean;
   DECLARE vbDiscountExternal    boolean;
   DECLARE vbDivisionParties     Boolean;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_BarCode());

  -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());

    -- ��� �����
    -- IF inSession = '3' then vbUnitId:= 1781716; END IF;

    -- ���� ������������
    vbObjectId := COALESCE (lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');
    -- ��������� ������ ������������
    vbAreaId:= (SELECT outAreaId FROM gpGet_Area_byUser (inSession));
    --
    IF COALESCE (vbAreaId, 0) = 0
    THEN
        vbAreaId:= (SELECT AreaId FROM gpGet_User_AreaId (inSession));
    END IF;


    -- �������� ��� ���������� �� ������
    SELECT Date_6, Date_3, Date_1, Date_0
    INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
    FROM lpSelect_PartionDateKind_SetDate ();


    IF EXISTS(SELECT 1 FROM ObjectBoolean AS ObjectBoolean_DividePartionDate
              WHERE ObjectBoolean_DividePartionDate.ObjectId = vbUnitId
                AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate())
    THEN

      SELECT COALESCE (ObjectBoolean_DividePartionDate.ValueData, FALSE)
      INTO vbDividePartionDate
      FROM ObjectBoolean AS ObjectBoolean_DividePartionDate
      WHERE ObjectBoolean_DividePartionDate.ObjectId = vbUnitId
        AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate();

    ELSE
      vbDividePartionDate := False;
    END IF;

    IF  zfGet_Unit_DiscountExternal (13216391, vbUnitId, vbUserId) = 13216391
    THEN
      vbDiscountExternal := True;
    ELSE
      vbDiscountExternal := False;
    END IF;

    vbDivisionParties := vbRetailId = 4;

                     
   RETURN QUERY 
       WITH 
           tmpGoods AS (SELECT 
                               Goods_Retail.Id             AS GoodsId
                                                                  
                         FROM Object AS Object_BarCode
                             LEFT JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                  ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                 AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_BarCode_Goods.ChildObjectId
                                 
                             LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                  ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                 AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                             LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId           
                             
                             LEFT JOIN Object_Goods_Retail AS Goods_4 ON Goods_4.Id  = ObjectLink_BarCode_Goods.ChildObjectId
                             LEFT JOIN Object_Goods_Retail AS Goods_Retail ON Goods_Retail.GoodsMainId = Goods_4.GoodsMainId
                                                                                 AND Goods_Retail.RetailId = vbRetailId
                         WHERE Object_BarCode.DescId = zc_Object_BarCode()
                           AND Object_BarCode.isErased = False
                           AND ObjectLink_BarCode_Object.ChildObjectId = inDiscountExternalId),
           tmpObject_Goods AS (SELECT Object_Goods_Retail.id 
                                    , Object_Goods_Retail.GoodsMainId 
                                    , Object_Goods_Main.NDSKindId
                                    , Object_Goods_Retail.Price
                                    , Object_Goods_Retail.isTop
                                    , COALESCE (Object_Goods_Retail.PercentMarkup, 0)   AS PercentMarkup
                                    , COALESCE (Object_Goods_Retail.Price, 0)           AS Price_retail
                               FROM Object_Goods_Retail
                                    LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                               WHERE Object_Goods_Retail.RetailId = vbRetailId
                                 AND Object_Goods_Retail.id IN (SELECT tmpGoods.GoodsId FROM tmpGoods))              

          -- ���������� �����������
         , tmpMovementID AS (SELECT
                                  Movement.Id
                                , Movement.DescId
                           FROM Movement
                           WHERE Movement.DescId IN (zc_Movement_Send(), zc_Movement_Check(), zc_Movement_TechnicalRediscount())
                            AND Movement.StatusId = zc_Enum_Status_UnComplete()
                         )
         , tmpMovementSend AS (SELECT
                                    Movement.Id
                             FROM tmpMovementID AS Movement

                                  INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                             ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                            AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                            AND MovementBoolean_Deferred.ValueData = TRUE

                                  INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                               AND MovementLinkObject_From.ObjectId = vbUnitId
                             WHERE  Movement.DescId = zc_Movement_Send()

                             )
         , tmpDeferredSendAll AS (SELECT
                                    Container.Id
                                  , Container.ParentId
                                  , SUM(- MovementItemContainer.Amount) AS Amount
                             FROM tmpMovementSend AS Movement

                                  INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.Id
                                                                  AND MovementItemContainer.DescId IN (zc_Container_Count(), zc_Container_CountPartionDate())

                                  INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId

                             GROUP BY Container.Id
                                    , Container.ParentId
                              )
         , tmpDeferredSendParrent  AS (SELECT tmpDeferredSendAll.ParentId
                                            , SUM(tmpDeferredSendAll.Amount) AS Amount
                                       FROM tmpDeferredSendAll
                                       GROUP BY tmpDeferredSendAll.ParentId
                                       )
         , tmpDeferredSendID  AS (SELECT tmpDeferredSendAll.Id
                                       , SUM(tmpDeferredSendAll.Amount) AS Amount
                                  FROM tmpDeferredSendAll
                                  GROUP BY tmpDeferredSendAll.Id
                                  )
         , tmpDeferredSend  AS (SELECT tmpDeferredSendID.Id
                                     , tmpDeferredSendID.Amount - COALESCE(tmpDeferredSendParrent.Amount, 0) AS Amount
                                FROM tmpDeferredSendID
                                     LEFT OUTER JOIN tmpDeferredSendParrent ON tmpDeferredSendParrent.ParentId = tmpDeferredSendID.Id
                                WHERE tmpDeferredSendID.Amount - COALESCE(tmpDeferredSendParrent.Amount, 0) <> 0
                                )
         , tmpDeferredSendNDSKindId AS (SELECT Movement.ParentId
                                             , CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                                                       OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
                                                       OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 13937605
                                                     THEN Object_Goods.NDSKindId ELSE MovementLinkObject_NDSKind.ObjectId END  AS NDSKindId
                                         FROM (SELECT DISTINCT tmpDeferredSendAll.ParentId FROM tmpDeferredSendAll) AS Movement

                                              INNER JOIN Container ON Container.Id = Movement.ParentId

                                              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                            ON ContainerLinkObject_MovementItem.Containerid = Container.Id
                                                                           AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                              LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                              -- ������� �������
                                              LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                              -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                                              LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                          ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                              -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                                              LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

                                              LEFT OUTER JOIN tmpObject_Goods AS Object_Goods ON Object_Goods.Id = Container.ObjectId

                                              LEFT OUTER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                                                              ON MovementBoolean_UseNDSKind.MovementId = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                                                             AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
                                              LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                                           ON MovementLinkObject_NDSKind.MovementId = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                                                          AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                          )
         -- ���������� ����������� ���������
         , tmpMovementTP AS (SELECT MovementItemMaster.ObjectId      AS GoodsId
                                  , SUM(-MovementItemMaster.Amount)   AS Amount
                             FROM tmpMovementID AS Movement

                                  INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                               AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                               AND MovementLinkObject_Unit.ObjectId = vbUnitId
                                                               
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
                               AND vbRetailId = 4
                               AND  MovementItemMaster.ObjectId IN (SELECT tmpGoods.GoodsId FROM tmpGoods)
                             GROUP BY MovementItemMaster.ObjectId
                             )
         -- ���������� ����
       , tmpMovementCheck AS (SELECT Movement.Id
                              FROM tmpMovementID AS Movement
                              WHERE Movement.DescId = zc_Movement_Check())
       , tmpMovReserveAll AS (
                             SELECT Movement.Id
                             FROM MovementBoolean AS MovementBoolean_Deferred
                                  INNER JOIN tmpMovementCheck AS Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                             WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                               AND MovementBoolean_Deferred.ValueData = TRUE
                             UNION ALL
                             SELECT Movement.Id
                             FROM MovementString AS MovementString_CommentError
                                  INNER JOIN tmpMovementCheck AS Movement ON Movement.Id     = MovementString_CommentError.MovementId
                             WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                               AND MovementString_CommentError.ValueData <> ''
                             )
       , tmpMovReserveId AS (SELECT DISTINCT Movement.Id
                             FROM tmpMovReserveAll AS Movement
                                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                                AND MovementLinkObject_Unit.ObjectId = vbUnitId
                             )
       , tmpReserve AS (SELECT MovementItemMaster.ObjectId                                          AS GoodsId
                             , COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods.NDSKindId)     AS NDSKindId
                             , MILinkObject_DiscountExternal.ObjectId                               AS DiscountExternalId
                             , MILinkObject_DivisionParties.ObjectId                                AS DivisionPartiesId
                             , SUM(COALESCE (MovementItemChild.Amount, MovementItemMaster.Amount))  AS Amount
                             , MIFloat_ContainerId.ValueData::Integer                               AS ContainerId
                        FROM tmpMovReserveId AS Movement

                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                          AND MovementLinkObject_Unit.ObjectId = vbUnitId

                             INNER JOIN MovementItem AS MovementItemMaster
                                                     ON MovementItemMaster.MovementId = Movement.Id
                                                    AND MovementItemMaster.DescId     = zc_MI_Master()
                                                    AND MovementItemMaster.isErased   = FALSE

                             LEFT OUTER JOIN tmpObject_Goods AS Object_Goods ON Object_Goods.Id = MovementItemMaster.ObjectId

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_NDSKind
                                                              ON MILinkObject_NDSKind.MovementItemId = MovementItemMaster.Id
                                                             AND MILinkObject_NDSKind.DescId = zc_MILinkObject_NDSKind()
                                                             AND COALESCE (MILinkObject_NDSKind.ObjectId, 0) <> 13937605

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_DiscountExternal
                                                              ON MILinkObject_DiscountExternal.MovementItemId = MovementItemMaster.Id
                                                             AND MILinkObject_DiscountExternal.DescId         = zc_MILinkObject_DiscountExternal()

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_DivisionParties
                                                              ON MILinkObject_DivisionParties.MovementItemId = MovementItemMaster.Id
                                                             AND MILinkObject_DivisionParties.DescId         = zc_MILinkObject_DivisionParties()
                                                             AND vbDivisionParties = TRUE

                             LEFT JOIN MovementItem AS MovementItemChild
                                                    ON MovementItemChild.MovementId = Movement.Id
                                                   AND MovementItemChild.ParentId = MovementItemMaster.Id
                                                   AND MovementItemChild.DescId     = zc_MI_Child()
                                                   AND MovementItemChild.Amount     > 0
                                                   AND MovementItemChild.isErased   = FALSE

                             LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                         ON MIFloat_ContainerId.MovementItemId = MovementItemChild.Id
                                                        AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                        WHERE MovementItemMaster.ObjectId IN (SELECT tmpGoods.GoodsId FROM tmpGoods)
                        GROUP BY MovementItemMaster.ObjectId
                               , MIFloat_ContainerId.ValueData
                               , COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods.NDSKindId)
                               , MILinkObject_DiscountExternal.ObjectId
                               , MILinkObject_DivisionParties.ObjectId
                        )
       , tmpContainerAll AS (SELECT Container.DescId
                                  , Container.Id
                                  , Container.ParentId
                                  , Container.ObjectId
                                  , Container.Amount + COALESCE (tmpDeferredSend.Amount, 0)           AS Amount
                                  , tmpDeferredSend.Amount                                            AS DeferredSend
                                  , ContainerLinkObject.ObjectId                                      AS PartionGoodsId
                                  , ContainerLinkObject_DivisionParties.ObjectId                      AS DivisionPartiesId
                             FROM Container

                                  LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                               AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                  LEFT JOIN ContainerlinkObject AS ContainerLinkObject_DivisionParties
                                                                ON ContainerLinkObject_DivisionParties.Containerid = COALESCE(Container.ParentId, Container.Id)
                                                               AND ContainerLinkObject_DivisionParties.DescId = zc_ContainerLinkObject_DivisionParties()

                                  LEFT JOIN tmpDeferredSend ON tmpDeferredSend.ID = Container.ID

                             WHERE Container.DescId  IN (zc_Container_Count(), zc_Container_CountPartionDate())
                               AND (Container.Amount <> 0 OR COALESCE (tmpDeferredSend.Amount, 0) <> 0)
                               AND Container.WhereObjectId = vbUnitId
                               AND Container.ObjectId IN (SELECT tmpGoods.GoodsId FROM tmpGoods)
                            )

       , tmpContainerPD AS (SELECT Container.Id
                                 , Container.ParentId
                                 , Container.ObjectId
                                 , Container.Amount
                                 , Container.DeferredSend
                                 , Container.DivisionPartiesId                                   AS DivisionPartiesId
                                 , Reserve.Amount                                                AS Reserve
                                 , COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd())  AS ExpirationDate
                                 , COALESCE (ObjectFloat_PartionGoods_ValueMin.ValueData, 0)     AS PercentMin
                                 , COALESCE (ObjectFloat_PartionGoods_ValueLess.ValueData, 0)    AS PercentLess
                                 , COALESCE (ObjectFloat_PartionGoods_Value.ValueData, 0)        AS Percent
                                 , CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0 AND
                                             COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                              THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 ��� (��������� ��� �������)
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- ����������
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- ������ 1 ������
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_3  THEN zc_Enum_PartionDateKind_3()      -- ������ 1 ������
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- ������ 6 ������
                                        ELSE  zc_Enum_PartionDateKind_Good() END  AS PartionDateKindId                              -- ����������� � ���������
                            FROM tmpContainerAll AS Container
                                 LEFT JOIN (SELECT tmpReserve.ContainerId, SUM(tmpReserve.Amount) AS Amount FROM tmpReserve GROUP BY tmpReserve.ContainerId) AS Reserve
                                                      ON Reserve.ContainerId = Container.ID
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
                            WHERE Container.DescId = zc_Container_CountPartionDate()
                             )
       , tmpContainerPDAll AS (SELECT tmpContainerPD.ParentId
                                      , SUM(tmpContainerPD.Amount - COALESCE (tmpContainerPD.DeferredSend, 0)) AS Amount
                                 FROM tmpContainerPD
                                 GROUP BY tmpContainerPD.ParentId
                                 )
       , tmpContainerIncome AS (SELECT Container.Id
                                     , Container.ObjectId
                                     , Container.Amount - COALESCE (tmpContainerPDAll.Amount, 0)       AS Amount
                                     , Container.DeferredSend
                                     , Container.DivisionPartiesId                                     AS DivisionPartiesId
                                     , COALESCE (MI_Income_find.Id,MI_Income.Id)                       AS MI_IncomeId
                                     , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)       AS M_IncomeId
                                     , zfPermit_Juridical_Discount (inDiscountExternalId
                                                                  , COALESCE(MovementLinkObject_From.ObjectId, 0)) > 0 AND
                                       COALESCE(MovementLinkObject_To.ObjectId, 0) = vbUnitId          AS isDiscount
                                FROM tmpContainerAll AS Container
                                     LEFT JOIN  tmpContainerPDAll on tmpContainerPDAll.ParentId = Container.Id
                                     LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                   ON ContainerLinkObject_MovementItem.Containerid = Container.Id
                                                                  AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                     LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                     -- ������� �������
                                     LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                     -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                                     LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                 ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                                AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                     -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                                     LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                                                          -- AND 1=0

                                     LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id =  MI_Income.MovementId
                                                                          AND Movement_Income.DescId = zc_Movement_Income()  
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                  ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                  ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                WHERE Container.DescId = zc_Container_Count()
                                )
       , tmpContainer AS (SELECT Container.Id
                               , Container.ObjectId
                               , Container.Amount
                               , CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                                        OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
                                        OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 13937605
                                 THEN Object_Goods.NDSKindId ELSE MovementLinkObject_NDSKind.ObjectId END  AS NDSKindId
                               , Container.DeferredSend
                               , MIDate_ExpirationDate.ValueData                                           AS ExpirationDate
                               , Container.DivisionPartiesId                                               AS DivisionPartiesId
                               , CASE WHEN vbDiscountExternal = TRUE
                                      THEN Object_Goods_Juridical.DiscountExternalID
                                      ELSE NULL END                                                        AS DiscountExternalID
                               , Container.isDiscount                                                      AS isDiscount
                          FROM tmpContainerIncome AS Container
                               LEFT OUTER JOIN tmpObject_Goods AS Object_Goods ON Object_Goods.Id = Container.ObjectId
                               LEFT OUTER JOIN MovementItemDate AS MIDate_ExpirationDate
                                                                ON MIDate_ExpirationDate.MovementItemId = Container.MI_IncomeId
                                                               AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                               LEFT OUTER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                                               ON MovementBoolean_UseNDSKind.MovementId = Container.M_IncomeId
                                                              AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                            ON MovementLinkObject_NDSKind.MovementId = Container.M_IncomeId
                                                           AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                               LEFT OUTER JOIN MovementItem ON MovementItem.Id = Container.MI_IncomeId
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                ON MILinkObject_Goods.MovementItemId = Container.MI_IncomeId
                                                               AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                               LEFT OUTER JOIN Object_Goods_Juridical ON Object_Goods_Juridical.Id = MILinkObject_Goods.ObjectID

                         )
       , tmpGoodsRemains AS (SELECT Container.ObjectId
                                  , Container.NDSKindId
                                  , Container.DiscountExternalID
                                  , Container.DivisionPartiesId
                                  , SUM(Container.Amount)                                                 AS Remains
                                  , SUM(CASE WHEN Container.isDiscount THEN Container.Amount ELSE 0 END)  AS RemainsDiscount
                                  , SUM(Container.DeferredSend)                                           AS DeferredSend
                                  , MIN(COALESCE (Container.ExpirationDate, zc_DateEnd()))                AS MinExpirationDate
                             FROM tmpContainer AS Container
                             WHERE Container.Amount <> 0
                             GROUP BY Container.ObjectId
                                    , Container.NDSKindId
                                    , Container.DiscountExternalID
                                    , Container.DivisionPartiesId
                             HAVING SUM(Container.Amount) <> 0 OR SUM(Container.DeferredSend) <> 0
                             )
       , tmpPDGoodsRemains AS (SELECT Container.ObjectId
                                    , COALESCE(tmpContainer.NDSKindId, tmpDeferredSendNDSKindId.NDSKindId,
                                                                                  Object_Goods.NDSKindId)  AS NDSKindId
                                    , tmpContainer.DiscountExternalID                                      AS DiscountExternalID
                                    , Container.PartionDateKindId                                          AS PartionDateKindId
                                    , Container.DivisionPartiesId                                          AS DivisionPartiesId
                                    , SUM (Container.Amount)                                               AS Remains
                                    , SUM(CASE WHEN tmpContainer.isDiscount THEN Container.Amount ELSE 0 END) AS RemainsDiscount
                                    , SUM (Container.Reserve)                                              AS Reserve
                                    , SUM (Container.DeferredSend)                                         AS DeferredSend
                                    , MIN (Container.ExpirationDate)::TDateTime                            AS MinExpirationDate

                                    , MIN (CASE WHEN Container.PartionDateKindId in (zc_Enum_PartionDateKind_Good(), zc_Enum_PartionDateKind_0())
                                                THEN 0
                                                WHEN Container.PartionDateKindId in (zc_Enum_PartionDateKind_6())
                                                THEN Container.Percent
                                                WHEN Container.PartionDateKindId in (zc_Enum_PartionDateKind_3(), zc_Enum_PartionDateKind_Cat_5())
                                                THEN Container.PercentLess
                                                WHEN Container.PartionDateKindId in (zc_Enum_PartionDateKind_1())
                                                THEN Container.PercentMin
                                                ELSE Null END)::TFloat                  AS PartionDateDiscount
                               FROM tmpContainerPD AS Container

                                    LEFT JOIN tmpContainer ON tmpContainer.Id = Container.ParentId

                                    LEFT JOIN tmpDeferredSendNDSKindId ON tmpDeferredSendNDSKindId.ParentId = Container.ParentId

                                    LEFT OUTER JOIN tmpObject_Goods AS Object_Goods ON Object_Goods.Id = Container.ObjectId

                               GROUP BY Container.ObjectId
                                      , COALESCE(tmpContainer.NDSKindId, tmpDeferredSendNDSKindId.NDSKindId, Object_Goods.NDSKindId)
                                      , tmpContainer.DiscountExternalID
                                      , Container.PartionDateKindId
                                      , Container.DivisionPartiesId
                               )
          -- ��������������� �������
       , GoodsRemains AS (SELECT Container.ObjectId
                               , Container.NDSKindId
                               , Container.DiscountExternalID
                               , Container.DivisionPartiesId
                               , Container.Remains - 
                                 COALESCE(Reserve.Amount, 0) -
                                 COALESCE(Container.DeferredSend, 0)               AS Remains
                               , CASE WHEN Container.Remains - 
                                           COALESCE(Reserve.Amount, 0) -
                                           COALESCE(Container.DeferredSend, 0) > Container.RemainsDiscount 
                                      THEN Container.RemainsDiscount 
                                      ELSE Container.Remains - 
                                           COALESCE(Reserve.Amount, 0) -
                                           COALESCE(Container.DeferredSend, 0) END AS RemainsDiscount
                               , Reserve.Amount                                    AS Reserve
                               , Container.DeferredSend
                               , Container.MinExpirationDate
                               , NULL::Integer                                     AS PartionDateKindId
                               , NULL::TFloat                                      AS PartionDateDiscount
                          FROM tmpGoodsRemains AS Container
                               LEFT JOIN tmpReserve AS Reserve
                                                    ON Reserve.GoodsId            = Container.ObjectId
                                                   AND Reserve.NDSKindId          = Container.NDSKindId
                                                   AND COALESCE (Reserve.DiscountExternalId, 0) = COALESCE (Container.DiscountExternalId, 0)
                                                   AND COALESCE (Reserve.DivisionPartiesId, 0) = COALESCE (Container.DivisionPartiesId, 0)
                                                   AND COALESCE (Reserve.ContainerId, 0 ) = 0
                          UNION ALL
                          SELECT Container.ObjectId
                               , Container.NDSKindId
                               , Container.DiscountExternalID
                               , Container.DivisionPartiesId
                               , Container.Remains - COALESCE(Container.Reserve, 0) -
                                                     COALESCE(Container.DeferredSend, 0)
                               , CASE WHEN Container.Remains - 
                                           COALESCE(Container.Reserve, 0) -
                                           COALESCE(Container.DeferredSend, 0) > Container.RemainsDiscount 
                                      THEN Container.RemainsDiscount 
                                      ELSE Container.Remains - 
                                           COALESCE(Container.Reserve, 0) -
                                           COALESCE(Container.DeferredSend, 0) END                    AS RemainsDiscount
                               , Container.Reserve
                               , Container.DeferredSend
                               , Container.MinExpirationDate
                               , Container.PartionDateKindId
                               , NULLIF (Container.PartionDateDiscount, 0)
                          FROM tmpPDGoodsRemains AS Container
                          UNION ALL
                          SELECT Reserve.GoodsId                                                       AS GoodsId
                               , Reserve.NDSKindId                                                     AS NDSKindId
                               , Reserve.DiscountExternalID                                            AS DiscountExternalID
                               , Reserve.DivisionPartiesId
                               , -Reserve.Amount                                                       AS Remains
                               , -Reserve.Amount                                                       AS RemainsDiscount
                               , Reserve.Amount                                                        AS Reserved
                               , NULL                                                                  AS DeferredSend
                               , Null::TDateTime                                                       AS MinExpirationDate
                               , NULL                                                                  AS PartionDateKindId
                               , NULL                                                                  AS PartionDateDiscount
                          FROM tmpReserve AS Reserve
                             LEFT OUTER JOIN tmpGoodsRemains ON Reserve.GoodsId            = tmpGoodsRemains.ObjectId
                                                            AND Reserve.NDSKindId          = tmpGoodsRemains.NDSKindId
                                                            AND COALESCE (Reserve.DiscountExternalID, 0) = COALESCE (tmpGoodsRemains.DiscountExternalID, 0)
                                                            AND COALESCE (Reserve.DivisionPartiesId, 0) = COALESCE (tmpGoodsRemains.DivisionPartiesId, 0)
                          WHERE COALESCE(tmpGoodsRemains.ObjectId, 0) = 0
                            AND COALESCE (Reserve.ContainerId, 0 ) = 0
                            AND Reserve.Amount <> 0
                          )
       , tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                     AND ObjectFloat_Goods_Price.ValueData > 0
                                    THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                    ELSE ROUND (Price_Value.ValueData, 2)
                               END :: TFloat                           AS Price
                             , MCS_Value.ValueData                     AS MCSValue
                             , Price_Goods.ChildObjectId               AS GoodsId
                        FROM ObjectLink AS ObjectLink_Price_Unit
                           LEFT JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                           LEFT JOIN ObjectFloat AS Price_Value
                                                 ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                           LEFT JOIN ObjectFloat AS MCS_Value
                                                 ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                           -- ���� ���� ��� ���� ����
                           LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                  ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                 AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                   ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                  AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                        WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                        )
       , tmpMovementItemTP AS (SELECT GoodsRemains.ObjectId                                             AS GoodsId
                                    , COALESCE (GoodsRemains.PartionDateKindId, 0)                      AS PartionDateKindId
                                    , GoodsRemains.NDSKindId                                            AS NDSKindId
                                    , COALESCE (GoodsRemains.DiscountExternalID, 0)                     AS DiscountExternalID
                                    , COALESCE (GoodsRemains.DivisionPartiesId, 0)                      AS DivisionPartiesId
                                    , tmpMovementTP.Amount                                              AS Amount
                                    , GoodsRemains.Remains                                              AS Remains
                                    , SUM (GoodsRemains.Remains) OVER (PARTITION BY GoodsRemains.ObjectId ORDER BY GoodsRemains.MinExpirationDate)
                               FROM tmpMovementTP
                                    INNER JOIN GoodsRemains ON GoodsRemains.ObjectId = tmpMovementTP.GoodsId
                               )
       , tmpMovementItemTPRemains AS (SELECT tmpMovementItemTP.GoodsId                           AS GoodsId
                                           , tmpMovementItemTP.PartionDateKindId                 AS PartionDateKindId
                                           , tmpMovementItemTP.NDSKindId                         AS NDSKindId
                                           , tmpMovementItemTP.DiscountExternalID                AS DiscountExternalID
                                           , tmpMovementItemTP.DivisionPartiesId                 AS DivisionPartiesId
                                           , CASE WHEN tmpMovementItemTP.Amount - tmpMovementItemTP.SUM > 0 THEN tmpMovementItemTP.Remains
                                                  ELSE tmpMovementItemTP.Amount - tmpMovementItemTP.SUM + tmpMovementItemTP.Remains
                                                  END                                                   AS Amount
                                      FROM tmpMovementItemTP
                                      WHERE (tmpMovementItemTP.Amount - (tmpMovementItemTP.SUM - tmpMovementItemTP.Remains) > 0)
                                        AND tmpMovementItemTP.GoodsId IN (SELECT tmpGoods.GoodsId FROM tmpGoods)  
                                      )

    SELECT GoodsRemains.ObjectId                                             AS GoodsId
         , COALESCE (GoodsRemains.PartionDateKindId, 0)                      AS PartionDateKindId
         , GoodsRemains.NDSKindId                                            AS NDSKindId
         , COALESCE (GoodsRemains.DiscountExternalID, 0)                     AS DiscountExternalID
         , COALESCE (GoodsRemains.DivisionPartiesId, 0)                      AS DivisionPartiesId
         , COALESCE(tmpObject_Price.Price,0)::TFloat                         AS Price
         , (GoodsRemains.Remains - 
           COALESCE (tmpMovementItemTPRemains.Amount, 0))::TFloat            AS Remains
         , (GoodsRemains.RemainsDiscount - 
           COALESCE (tmpMovementItemTPRemains.Amount, 0))::TFloat            AS RemainsDiscount
         , NULLIF (GoodsRemains.Reserve, 0)::TFloat                          AS Reserved
         , NULLIF (GoodsRemains.DeferredSend, 0)::TFloat                     AS DeferredSend
         , NULLIF (tmpMovementItemTPRemains.Amount, 0)::TFloat               AS DeferredTR
    FROM
        GoodsRemains
        LEFT OUTER JOIN tmpObject_Price ON tmpObject_Price.GoodsId = GoodsRemains.ObjectId
        
        LEFT OUTER JOIN tmpMovementItemTPRemains ON tmpMovementItemTPRemains.GoodsId            = GoodsRemains.ObjectId
                                                AND tmpMovementItemTPRemains.PartionDateKindId  = COALESCE (GoodsRemains.PartionDateKindId, 0) 
                                                AND tmpMovementItemTPRemains.NDSKindId          = GoodsRemains.NDSKindId 
                                                AND tmpMovementItemTPRemains.DiscountExternalID = COALESCE (GoodsRemains.DivisionPartiesId, 0)  
                                                AND tmpMovementItemTPRemains.DivisionPartiesId  = COALESCE (GoodsRemains.DivisionPartiesId, 0)

        LEFT OUTER JOIN AccommodationLincGoods AS Accommodation
                                               ON Accommodation.UnitId = vbUnitId
                                              AND Accommodation.GoodsId = GoodsRemains.ObjectId
                                              AND Accommodation.isErased = False;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.03.21                                                       *

*/

-- ����
-- 
select * from gpSelect_DiscountExternal_RemainsUnitOne(inDiscountExternalId := 4521216 ,  inSession := '3');
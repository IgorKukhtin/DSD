-- Function: gpSelect_MovementItem_Send_Child()

--DROP FUNCTION IF EXISTS gpSelect_MovementItem_Send_Child (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Send_Child(
    IN inMovementId  Integer      , -- ���� ���������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, ParentId integer
             , GoodsId Integer --, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , ContainerId TFloat
             , ExpirationDate      TDateTime
             , OperDate_Income     TDateTime
             , Invnumber_Income    TVarChar
             , FromName_Income     TVarChar
             , ContractName_Income TVarChar
             , PartionDateKindName TVarChar
             , DateInsert          TDateTime
             , PartyRelated        Boolean
             , Color_calc          Integer
             , isErased            Boolean
              )
AS
$BODY$
  DECLARE vbOperDate TDateTime;
  DECLARE vbUserId Integer;
  DECLARE vbDate_6 TDateTime;
  DECLARE vbDate_3 TDateTime;
  DECLARE vbDate_1 TDateTime;
  DECLARE vbDate_0 TDateTime;

  DECLARE vbUnitId Integer;
  DECLARE vbJuridicalId Integer;
  DECLARE vbPartionDateId Integer;
  DECLARE vbisSUN      Boolean;
  DECLARE vbisDeferred Boolean;
  DECLARE vbStatusID   Integer;
  DECLARE vbisBanFiscalSale Boolean;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Send());
    vbUserId := inSession;

    -- ��������� ���������
    SELECT Movement.OperDate
         , Movement.StatusID
         , MovementLinkObject_From.ObjectId
         , OL_Unit_Juridical.ChildObjectId
         , COALESCE (MovementBoolean_DefSUN.ValueData, FALSE)
         , COALESCE (MovementLinkObject_PartionDateKind.ObjectId, 0)
         , COALESCE (MovementBoolean_Deferred.ValueData, FALSE) ::Boolean
         , COALESCE (MovementBoolean_BanFiscalSale.ValueData, FALSE)
    INTO vbOperDate
       , vbStatusID
       , vbUnitId
       , vbJuridicalId
       , vbisSUN
       , vbPartionDateId
       , vbisDeferred
       , vbisBanFiscalSale
    FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
         LEFT JOIN ObjectLink AS OL_Unit_Juridical
                              ON OL_Unit_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                             AND OL_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical()
         LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                   ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                  AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_SUN()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                      ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                     AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
         LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                   ON MovementBoolean_Deferred.MovementId = Movement.Id
                                  AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
         LEFT JOIN MovementBoolean AS MovementBoolean_BanFiscalSale
                                   ON MovementBoolean_BanFiscalSale.MovementId = Movement.Id
                                  AND MovementBoolean_BanFiscalSale.DescId = zc_MovementBoolean_BanFiscalSale()
    WHERE Movement.Id = inMovementId;

    -- �������� ��� ���������� �� ������
    SELECT Date_6, Date_3, Date_1, Date_0
    INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
    FROM lpSelect_PartionDateKind_SetDate ();
   
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpMI_Child'))
    THEN
      DROP TABLE tmpMI_Child;
    END IF;
	
    CREATE TEMP TABLE tmpMI_Child ON COMMIT DROP AS 
                    (SELECT MovementItem.*
                     FROM MovementItem
                     WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId = zc_MI_Child()
                        AND MovementItem.Amount > 0
                     );
                    
    ANALYSE tmpMI_Child;
   
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpMI_Master'))
    THEN
      DROP TABLE tmpMI_Master;
    END IF;
	
    CREATE TEMP TABLE tmpMI_Master ON COMMIT DROP AS 
          (WITH
           tmpMI_ChildSUM AS (SELECT MovementItem.ParentID
                                   , SUM(MovementItem.Amount)   AS Amount
                              FROM tmpMI_Child AS MovementItem
                              GROUP BY MovementItem.ParentID
                               )
                               
                            SELECT MovementItem.Id
                                 , MovementItem.ObjectID
                                 , MovementItem.Amount - COALESCE(tmpMI_ChildSUM.Amount, 0) AS Amount  
                                 , MovementItem.isErased 
                            FROM MovementItem
                            
                                 LEFT JOIN tmpMI_ChildSUM ON tmpMI_ChildSUM.ParentID = MovementItem.ID 
                                 
                            WHERE MovementItem.MovementId = inMovementId
                               AND MovementItem.DescId = zc_MI_Master()
                              -- AND MovementItem.Amount > 0
                              -- AND MovementItem.isErased = FALSE
                              -- AND MovementItem.ID not In (SELECT tmpMI_Child.ParentID FROM tmpMI_Child)
                            );
                           
     ANALYSE tmpMI_Master;

     IF vbStatusID = zc_Enum_Status_Complete() OR vbisDeferred = TRUE
     THEN

       raise notice 'Value 1: %', CLOCK_TIMESTAMP();

       -- ��� ����������� � ���������� ���������� ��� ������� ���������
       
        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpMIFloat_ContainerId'))
        THEN
          DROP TABLE tmpMIFloat_ContainerId;
        END IF;

        CREATE TEMP TABLE tmpMIFloat_ContainerId ON COMMIT DROP AS 
        SELECT MovementItemFloat.MovementItemId
             , MovementItemFloat.ValueData::Integer  AS ContainerId
        FROM MovementItemFloat
        WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI_Child.Id FROM tmpMI_Child WHERE tmpMI_Child.IsErased = FALSE)
          AND MovementItemFloat.DescId = zc_MIFloat_ContainerId();

        ANALYSE tmpMIFloat_ContainerId;
        
        raise notice 'Value 2: %', CLOCK_TIMESTAMP();

        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpMI_Container'))
        THEN
          DROP TABLE tmpMI_Container;
        END IF;

        CREATE TEMP TABLE tmpMI_Container ON COMMIT DROP AS 
        SELECT *
        FROM Container
        WHERE Container.ID in (SELECT tmpMIFloat_ContainerId.ContainerId FROM tmpMIFloat_ContainerId);

        ANALYSE tmpMI_Container;
        
        raise notice 'Value 3: %', CLOCK_TIMESTAMP();
        
        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpMIContainerPD'))
        THEN
          DROP TABLE tmpMIContainerPD;
        END IF;

        CREATE TEMP TABLE tmpMIContainerPD ON COMMIT DROP AS 
        SELECT MovementItemContainer.MovementItemID     AS Id
             , Container.Id                             AS ContainerId
             , Container.ParentId                       AS ParentId
             , MovementItemContainer.Amount             AS Amount
         FROM  MovementItemContainer

               INNER JOIN Container ON Container.ID = MovementItemContainer.ContainerID

         WHERE MovementItemContainer.MovementId = inMovementId
           AND MovementItemContainer.DescId = zc_Container_CountPartionDate();

        ANALYSE tmpMIContainerPD;
        
        raise notice 'Value 4: %', CLOCK_TIMESTAMP();

        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpMIContainerAll'))
        THEN
          DROP TABLE tmpMIContainerAll;
        END IF;

        CREATE TEMP TABLE tmpMIContainerAll ON COMMIT DROP AS 
         SELECT MovementItemContainer.MovementItemID      AS MovementItemId
              , MovementItemContainer.ContainerID        AS ContainerID
              , MovementItemContainer.DescId
              , - COALESCE(tmpMIContainerPD.Amount, MovementItemContainer.Amount) AS Amount
              , CLO_PartionGoods.ObjectId                                         AS PartionGoodsId   
         FROM  MovementItemContainer

               INNER JOIN Container ON Container.ID = MovementItemContainer.ContainerID
                                         
               LEFT JOIN tmpMIContainerPD ON tmpMIContainerPD.Id  = MovementItemContainer.MovementItemID
                                         AND tmpMIContainerPD.ParentId  = Container.ID

               LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                             ON CLO_PartionGoods.ContainerId = tmpMIContainerPD.ContainerId
                                            AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                                      
         WHERE MovementItemContainer.MovementId = inMovementId
           AND MovementItemContainer.DescId = zc_Container_Count()
           AND COALESCE(MovementItemContainer.isActive, FALSE) = FALSE
           AND (- MovementItemContainer.Amount - COALESCE(tmpMIContainerPD.Amount, 0)) <> 0;

        ANALYSE tmpMIContainerAll;
        
        raise notice 'Value 6: %', CLOCK_TIMESTAMP();
                
        /*IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpContainerTo'))
        THEN
          DROP TABLE tmpContainerTo;
        END IF;

        CREATE TEMP TABLE tmpContainerTo ON COMMIT DROP AS 
        SELECT Container.ObjectId                                          AS ObjectId
             , MovementLinkObject_From.ObjectId                            AS FromId
        FROM Container 

             LEFT JOIN MovementItemContainer AS MIC
                                             ON MIC.Containerid = Container.Id
                                            AND MIC.MovementDescId = zc_Movement_Income()
                                            AND MIC.OperDate >= vbOperDate - INTERVAL '30 MONTH'
                                            AND MIC.OperDate < vbOperDate

             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = MIC.MovementId
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                         
        WHERE Container.DescId = zc_Container_Count()
          AND Container.WhereObjectId in (SELECT OL_Unit_Juridical.ObjectId FROM ObjectLink AS OL_Unit_Juridical
                                          WHERE OL_Unit_Juridical.ChildObjectId = vbJuridicalId
                                            AND OL_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical())
          AND Container.ObjectId in (SELECT DISTINCT MovementItem.ObjectId
                                     FROM MovementItem
                                     WHERE MovementItem.MovementId = inMovementId
                                        AND MovementItem.DescId = zc_MI_Master()
                                        AND MovementItem.Amount > 0
                                        AND MovementItem.isErased = FALSE)

         GROUP BY Container.ObjectId
                , MovementLinkObject_From.ObjectId;

        ANALYSE tmpContainerTo;*/
        
        raise notice 'Value 7: %', CLOCK_TIMESTAMP();
        
        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpContainer'))
        THEN
          DROP TABLE tmpContainer;
        END IF;

        CREATE TEMP TABLE tmpContainer ON COMMIT DROP AS 
        SELECT tmp.MovementItemID
             , tmp.ContainerId
             , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId) AS MovementId_Income
             , COALESCE (ObjectDate_Value.ValueData, MIDate_ExpirationDate.ValueData, zc_DateEnd())  AS ExpirationDate
             , tmp.Amount
             , CASE WHEN ObjectDate_Value.ValueData <= vbDate_0 AND
                         COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                 THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 ��� (��������� ��� �������)
                    WHEN ObjectDate_Value.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- ����������
                    WHEN ObjectDate_Value.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- ������ 1 ������
                    WHEN ObjectDate_Value.ValueData <= vbDate_3  THEN zc_Enum_PartionDateKind_3()      -- ������ 3 ������
                    WHEN ObjectDate_Value.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- ������ 6 ������
                    WHEN ObjectDate_Value.ValueData > vbDate_6   THEN zc_Enum_PartionDateKind_Good()  END  AS PartionDateKindId                              -- ����������� � ���������
        FROM tmpMIContainerAll AS tmp
             LEFT OUTER JOIN ObjectDate AS ObjectDate_Value
                                        ON ObjectDate_Value.ObjectId = tmp.PartionGoodsId
                                       AND ObjectDate_Value.DescId   =  zc_ObjectDate_PartionGoods_Value()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                     ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = tmp.PartionGoodsId
                                    AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()

             LEFT JOIN ContainerlinkObject AS CLO_MovementItem
                                           ON CLO_MovementItem.Containerid = tmp.ContainerId
                                          AND CLO_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
             LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_MovementItem.ObjectId
             -- ������� �������
             LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
             -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
             LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                         ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                        AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
             -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
             LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

             LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                               ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                              AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods();

        ANALYSE tmpContainer;
        
        raise notice 'Value 8: %', CLOCK_TIMESTAMP();
        
        
        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpPartion'))
        THEN
          DROP TABLE tmpPartion;
        END IF;

        CREATE TEMP TABLE tmpPartion ON COMMIT DROP AS 
        SELECT Movement.Id
             , MovementDate_Branch.ValueData    AS BranchDate
             , Movement.Invnumber               AS Invnumber
             , MovementLinkObject_From.ObjectId AS FromId
             , Object_From.ValueData            AS FromName
             , Object_Contract.ValueData        AS ContractName
        FROM Movement
             LEFT JOIN MovementDate AS MovementDate_Branch
                                    ON MovementDate_Branch.MovementId = Movement.Id
                                   AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
             LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                          ON MovementLinkObject_Contract.MovementId = Movement.Id
                                         AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
             LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
        WHERE Movement.Id IN (SELECT DISTINCT tmpContainer.MovementId_Income FROM tmpContainer);

        ANALYSE tmpPartion;
        
        raise notice 'Value 9: %', CLOCK_TIMESTAMP();
        

       RETURN QUERY
       WITH
           tmpMI_Child_ContainerId AS (SELECT Container.ParentId                  AS ContainerId
                                            , Container.Id                        AS ContainerPDId
                                            , MovementItem.Id                     AS MovementItemId
                                            , MovementItem.ParentID               AS ParentID
                                            , SUM(MovementItem.Amount)            AS Amount
                                       FROM tmpMI_Child AS MovementItem
                                            INNER JOIN tmpMIFloat_ContainerId ON tmpMIFloat_ContainerId.MovementItemId = MovementItem.ID
                                            INNER JOIN tmpMI_Container AS Container ON Container.Id = tmpMIFloat_ContainerId.ContainerId
                                       GROUP BY MovementItem.Id, MovementItem.ParentID, Container.ParentId, Container.Id
                                       )
          --

         SELECT
               COALESCE(tmpMI_Child_ContainerId.MovementItemId, 0)            AS ID
             , COALESCE(MovementItem.ParentId, MovementItem.Id)               AS ParentId
             , MovementItem.ObjectId                                          AS GoodsId
--             , Object_Goods.ObjectCode    AS GoodsCode
  --           , Object_Goods.ValueData     AS GoodsName
             , Container.Amount::TFloat   AS Amount

             , Container.ContainerId:: TFloat                                 AS ContainerId
             , COALESCE (Container.ExpirationDate, NULL)        :: TDateTime  AS ExpirationDate
             , COALESCE (tmpPartion.BranchDate, NULL)           :: TDateTime  AS OperDate_Income
             , COALESCE (tmpPartion.Invnumber, NULL)            :: TVarChar   AS Invnumber_Income
             , COALESCE (tmpPartion.FromName, NULL)             :: TVarChar   AS FromName_Income
             , COALESCE (tmpPartion.ContractName, NULL)         :: TVarChar   AS ContractName_Income

             , Object_PartionDateKind.ValueData                  :: TVarChar  AS PartionDateKindName
             , DATE_TRUNC ('DAY', MIDate_Insert.ValueData)       :: TDateTime AS DateInsert
             , CASE WHEN COALESCE(tmpMI_Child_ContainerId.MovementItemId, 0) = 0 THEN FALSE ELSE TRUE END AS PartyRelated

             --, CASE WHEN COALESCE(tmpContainerTo.ObjectId, 0) <> 0 THEN zc_Color_Black() ELSE zc_Color_Red() END  AS Color_calc
             , zc_Color_Black() AS Color_calc
             , MovementItem.isErased                                            AS isErased
         FROM tmpContainer AS Container

              LEFT JOIN MovementItem ON MovementItem.ID = Container.MovementItemId

              LEFT JOIN tmpMI_Child_ContainerId ON tmpMI_Child_ContainerId.ContainerPDId = Container.ContainerId
                                               AND tmpMI_Child_ContainerId.MovementItemId = MovementItem.Id

--              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

              LEFT JOIN tmpPartion ON tmpPartion.Id = Container.MovementId_Income
              LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = Container.PartionDateKindId
              LEFT OUTER JOIN MovementItemDate  AS MIDate_Insert
                                                ON MIDate_Insert.MovementItemId = MovementItem.Id
                                               AND MIDate_Insert.DescId = zc_MIDate_Insert()
              /*LEFT OUTER JOIN tmpContainerTo ON tmpContainerTo.ObjectId = MovementItem.ObjectId
                                            AND tmpContainerTo.FromId = tmpPartion.FromId*/
         ;

        raise notice 'Value 10: %', CLOCK_TIMESTAMP();

     ELSEIF vbisSUN = TRUE
     THEN

       -- ��� �� ����������� �������������� ��������

       RETURN QUERY
       WITH
           tmpMIFloat_ContainerId AS (SELECT MovementItemFloat.MovementItemId
                                           , MovementItemFloat.ValueData::Integer  AS ContainerId
                                      FROM MovementItemFloat
                                      WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI_Child.Id FROM tmpMI_Child)
                                        AND MovementItemFloat.DescId = zc_MIFloat_ContainerId()
                                      )
         , tmpMI_Container AS (SELECT *
                                      FROM Container
                                      WHERE Container.ID in (SELECT tmpMIFloat_ContainerId.ContainerId FROM tmpMIFloat_ContainerId)
                                      )
         , tmpMI_Child_ContainerId AS (SELECT Container.ParentId                  AS ContainerId
                                            , Container.Id                        AS ContainerPDId
                                            , MovementItem.Id                     AS MovementItemId
                                            , MovementItem.ParentID               AS ParentID
                                            , SUM(MovementItem.Amount)            AS Amount
                                       FROM tmpMI_Child AS MovementItem
                                            LEFT JOIN tmpMIFloat_ContainerId ON tmpMIFloat_ContainerId.MovementItemId = MovementItem.ID
                                            LEFT JOIN tmpMI_Container AS Container ON Container.Id = tmpMIFloat_ContainerId.ContainerId
                                       GROUP BY MovementItem.Id, MovementItem.ParentID, Container.ParentId, Container.Id
                                       )
          , tmpContainerPD AS (SELECT Container.ParentId                                          AS ContainerId
                                    , Min(Container.Id)                                           AS ContainerPDId
                                    , Min(ObjectDate_Value.ValueData)                             AS ExpirationDate
                                    , CASE WHEN Min(ObjectDate_Value.ValueData) <= vbDate_0  THEN 6      -- ����������
                                           WHEN Min(ObjectDate_Value.ValueData) <= vbDate_1  THEN 5      -- ������ 1 ������
                                           WHEN Min(ObjectDate_Value.ValueData) <= vbDate_3  THEN 4      -- ������ 3 ������
                                           WHEN Min(ObjectDate_Value.ValueData) <= vbDate_6  THEN 1      -- ������ 6 ������
                                           ELSE  2 END  AS PDOrd                                                  -- ����������� � ���������
                               FROM (SELECT DISTINCT tmpMI_Master.ObjectId FROM tmpMI_Master) AS tmpMI
                                    INNER JOIN Container ON Container.DescId = zc_Container_CountPartionDate()
                                                        AND Container.WhereObjectId = vbUnitId
                                                        AND Container.ObjectId = tmpMI.ObjectId
                                                        AND Container.Amount > 0
                                        LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                      ON CLO_PartionGoods.ContainerId = Container.Id
                                                                     AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                        LEFT OUTER JOIN ObjectDate AS ObjectDate_Value
                                                                   ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                  AND ObjectDate_Value.DescId   =  zc_ObjectDate_PartionGoods_Value()
                               GROUP BY Container.ParentId
                               )
         , REMAINS AS ( --�������
                       SELECT Container.Id
                            , Container.ObjectId --�����
                            , Container.Amount - COALESCE(tmpMI_Child_ContainerId.Amount, 0) AS Amount  --���. �������
                            , COALESCE (tmpContainerPD.PDOrd, 3) AS PDOrd
                       FROM Container
                            INNER JOIN tmpMI_Master ON tmpMI_Master.ObjectId = Container.ObjectId
                            LEFT JOIN tmpMI_Child_ContainerId ON tmpMI_Child_ContainerId.ContainerId = Container.Id
                            LEFT JOIN tmpContainerPD ON tmpContainerPD.ContainerId = Container.Id
                            LEFT JOIN ContainerlinkObject AS ContainerLinkObject_DivisionParties
                                                          ON ContainerLinkObject_DivisionParties.Containerid = Container.Id
                                                         AND ContainerLinkObject_DivisionParties.DescId = zc_ContainerLinkObject_DivisionParties()                                                              
                            LEFT JOIN ObjectBoolean AS ObjectBoolean_BanFiscalSale
                                                    ON ObjectBoolean_BanFiscalSale.ObjectId = ContainerLinkObject_DivisionParties.ObjectId
                                                   AND ObjectBoolean_BanFiscalSale.DescId = zc_ObjectBoolean_DivisionParties_BanFiscalSale()                                                          
                       WHERE Container.DescID = zc_Container_Count()
                         AND Container.WhereObjectId = vbUnitId
                         AND Container.Amount - COALESCE(tmpMI_Child_ContainerId.Amount, 0) > 0
                         AND (vbisBanFiscalSale = False OR vbisBanFiscalSale = True AND COALESCE (ObjectBoolean_BanFiscalSale.ValueData, False) = True)
                       )
          , DD AS (SELECT tmpMI_Master.ID     AS MovementItemId
                        , tmpMI_Master.Amount
                        , REMAINS.Amount      AS ContainerAmount
                        , REMAINS.Id          AS ContainerId
                        , SUM (REMAINS.Amount) OVER (PARTITION BY REMAINS.ObjectId ORDER BY REMAINS.PDOrd, Movement.OperDate, REMAINS.Id, tmpMI_Master.Id)
                   FROM REMAINS
                        JOIN tmpMI_Master ON tmpMI_Master.objectid = REMAINS.objectid
                        JOIN containerlinkobject AS CLI_MI
                                                 ON CLI_MI.containerid = REMAINS.Id
                                                AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                        JOIN containerlinkobject AS CLI_Unit
                                                 ON CLI_Unit.containerid = REMAINS.Id
                                                AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                                AND CLI_Unit.ObjectId = vbUnitId
                        JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                        JOIN movementitem ON movementitem.Id = Object_PartionMovementItem.ObjectCode
                        JOIN Movement ON Movement.Id = movementitem.movementid
                    WHERE REMAINS.Amount > 0)
          , tmpMIContainerAll AS (SELECT
                                         NULL::Integer    AS ID
                                       , DD.ContainerId
                                       , NULL::Integer    AS ContainerPDId
                                       , DD.MovementItemId
                                       , CASE
                                           WHEN DD.Amount - DD.SUM > 0 THEN DD.ContainerAmount
                                           ELSE DD.Amount - DD.SUM + DD.ContainerAmount
                                         END AS Amount
                                   FROM DD
                                   WHERE (DD.Amount - (DD.SUM - DD.ContainerAmount) > 0)
                                   UNION ALL
                                   SELECT tmpMI_Child_ContainerId.MovementItemId
                                        , tmpMI_Child_ContainerId.ContainerId
                                        , tmpMI_Child_ContainerId.ContainerPDId
                                        , tmpMI_Child_ContainerId.ParentID
                                        , tmpMI_Child_ContainerId.Amount
                                   FROM tmpMI_Child_ContainerId
                                        )
          , tmpContainerPDDate AS (SELECT ContainerAll.ContainerPDId                                        AS ContainerPDId
                                        , ObjectDate_Value.ValueData                                        AS ExpirationDate
                                   FROM (SELECT DISTINCT tmpMI_Child_ContainerId.ContainerPDId FROM tmpMI_Child_ContainerId) AS ContainerAll
                                        LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                      ON CLO_PartionGoods.ContainerId = ContainerAll.ContainerPDId
                                                                     AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                        LEFT OUTER JOIN ObjectDate AS ObjectDate_Value
                                                                   ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                  AND ObjectDate_Value.DescId   =  zc_ObjectDate_PartionGoods_Value()
                                   )

         , tmpContainer AS (SELECT tmp.ContainerId
                                 , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId) AS MovementId_Income
                                 , COALESCE (ObjectDate_Value.ValueData, MIDate_ExpirationDate.ValueData, zc_DateEnd())  AS ExpirationDate
                                 , CASE WHEN ObjectDate_Value.ValueData <= vbDate_0 AND
                                             COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                              THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 ��� (��������� ��� �������)
                                        WHEN ObjectDate_Value.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- ����������
                                        WHEN ObjectDate_Value.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- ������ 1 ������
                                        WHEN ObjectDate_Value.ValueData <= vbDate_3  THEN zc_Enum_PartionDateKind_3()      -- ������ 3 ������
                                        WHEN ObjectDate_Value.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- ������ 6 ������
                                        WHEN ObjectDate_Value.ValueData > vbDate_6   THEN zc_Enum_PartionDateKind_Good()  END  AS PartionDateKindId                              -- ����������� � ���������
                            FROM (SELECT DISTINCT tmpMIContainerAll.ContainerId FROM tmpMIContainerAll) AS tmp

                                 LEFT JOIN tmpContainerPD ON tmpContainerPD.ContainerId = tmp.ContainerId

                                 LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                               ON CLO_PartionGoods.ContainerId = tmpContainerPD.ContainerPDId
                                                              AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                 LEFT OUTER JOIN ObjectDate AS ObjectDate_Value
                                                            ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                           AND ObjectDate_Value.DescId   =  zc_ObjectDate_PartionGoods_Value()
                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                         ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = CLO_PartionGoods.ObjectId
                                                        AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()

                                 LEFT JOIN ContainerlinkObject AS CLO_MovementItem
                                                               ON CLO_MovementItem.Containerid = tmp.ContainerId
                                                              AND CLO_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                 LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_MovementItem.ObjectId
                                 -- ������� �������
                                 LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                 -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                                 LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                             ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                            AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                 -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                                 LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                                 LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                                   ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                                  AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                           )
          --
         , tmpPartion AS (SELECT Movement.Id
                               , MovementDate_Branch.ValueData    AS BranchDate
                               , Movement.Invnumber               AS Invnumber
                               , MovementLinkObject_From.ObjectId AS FromId
                               , Object_From.ValueData            AS FromName
                               , Object_Contract.ValueData        AS ContractName
                          FROM Movement
                               LEFT JOIN MovementDate AS MovementDate_Branch
                                                      ON MovementDate_Branch.MovementId = Movement.Id
                                                     AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                               LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                               LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
                          WHERE Movement.Id IN (SELECT DISTINCT tmpContainer.MovementId_Income FROM tmpContainer)
                          )
         , tmpContainerTo AS (SELECT Container.ObjectId                                          AS ObjectId
                                   , MovementLinkObject_From.ObjectId                            AS FromId
                              FROM (SELECT DISTINCT MovementItem.ObjectId
                                    FROM MovementItem
                                    WHERE MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId = zc_MI_Master()
                                    --   AND MovementItem.Amount > 0
                                       AND MovementItem.isErased = FALSE) AS tmpMI
                                   INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                                       AND Container.WhereObjectId in (SELECT OL_Unit_Juridical.ObjectId FROM ObjectLink AS OL_Unit_Juridical
                                                                                       WHERE OL_Unit_Juridical.ChildObjectId = vbJuridicalId
                                                                                         AND OL_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical())
                                                       AND Container.ObjectId = tmpMI.ObjectId

                                   LEFT JOIN MovementItemContainer AS MIC
                                                                   ON MIC.Containerid = Container.Id
                                                                  AND MIC.MovementDescId = zc_Movement_Income()
                                                                  AND MIC.OperDate >= vbOperDate - INTERVAL '30 MONTH'
                                                                  AND MIC.OperDate < vbOperDate

                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                ON MovementLinkObject_From.MovementId = MIC.MovementId
                                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                               
                               GROUP BY Container.ObjectId
                                      , MovementLinkObject_From.ObjectId
                               )


         SELECT
               Container.ID::Integer      AS ID
             , MovementItem.Id            AS ParentId
             , MovementItem.ObjectId      AS GoodsId
--             , Object_Goods.ObjectCode    AS GoodsCode
  --           , Object_Goods.ValueData     AS GoodsName
             , Container.Amount::TFloat   AS Amount

             , COALESCE (Container.ContainerPDId, Container.ContainerId)  :: TFloat      AS ContainerId
             , COALESCE (tmpContainerPDDate.ExpirationDate, tmpContainer.ExpirationDate, NULL)  :: TDateTime   AS ExpirationDate
             , COALESCE (tmpPartion.BranchDate, NULL)            :: TDateTime   AS OperDate_Income
             , COALESCE (tmpPartion.Invnumber, NULL)             :: TVarChar    AS Invnumber_Income
             , COALESCE (tmpPartion.FromName, NULL)              :: TVarChar    AS FromName_Income
             , COALESCE (tmpPartion.ContractName, NULL)          :: TVarChar    AS ContractName_Income

             , Object_PartionDateKind.ValueData                  :: TVarChar    AS PartionDateKindName
             , DATE_TRUNC ('DAY', MIDate_Insert.ValueData)       :: TDateTime   AS DateInsert
             , CASE WHEN COALESCE(Container.ID, 0) = 0 THEN FALSE ELSE TRUE END AS PartyRelated
             --, CASE WHEN COALESCE(tmpContainerTo.ObjectId, 0) <> 0 THEN zc_Color_Black() ELSE zc_Color_Red() END  AS Color_calc
             , zc_Color_Black() AS Color_calc
             , MovementItem.isErased                                            AS isErased
         FROM tmpMIContainerAll AS Container

              LEFT JOIN tmpMI_Master AS MovementItem ON MovementItem.ID = Container.MovementItemId

--              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

              LEFT JOIN tmpContainer ON tmpContainer.ContainerId = Container.ContainerId
              LEFT JOIN tmpContainerPDDate ON tmpContainerPDDate.ContainerPDId = Container.ContainerPDId
              LEFT JOIN tmpPartion ON tmpPartion.Id= tmpContainer.MovementId_Income
              LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = tmpContainer.PartionDateKindId
              LEFT OUTER JOIN MovementItemDate  AS MIDate_Insert
                                                ON MIDate_Insert.MovementItemId = MovementItem.Id
                                               AND MIDate_Insert.DescId = zc_MIDate_Insert()
              /*LEFT OUTER JOIN tmpContainerTo ON tmpContainerTo.ObjectId = MovementItem.ObjectId
                                            AND tmpContainerTo.FromId = tmpPartion.FromId*/
         ;

       raise notice 'Value 20: %', CLOCK_TIMESTAMP();

     ELSE

       -- ��� �� ����������� �������������� ��������
       
       RETURN QUERY
       WITH
           tmpMIFloat_ContainerId AS (SELECT MovementItemFloat.MovementItemId
                                           , MovementItemFloat.ValueData::Integer  AS ContainerId
                                      FROM MovementItemFloat
                                      WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI_Child.Id FROM tmpMI_Child)
                                        AND MovementItemFloat.DescId = zc_MIFloat_ContainerId()
                                      )
         , tmpMI_Container AS (SELECT *
                                      FROM Container
                                      WHERE Container.ID in (SELECT tmpMIFloat_ContainerId.ContainerId FROM tmpMIFloat_ContainerId)
                                      )
         , tmpMI_Child_ContainerId AS (SELECT Container.ParentId                  AS ContainerId
                                            , Container.Id                        AS ContainerPDId
                                            , MovementItem.Id                     AS MovementItemId
                                            , MovementItem.ParentID               AS ParentID
                                            , SUM(MovementItem.Amount)            AS Amount
                                       FROM tmpMI_Child AS MovementItem
                                            LEFT JOIN tmpMIFloat_ContainerId ON tmpMIFloat_ContainerId.MovementItemId = MovementItem.ID
                                            LEFT JOIN tmpMI_Container AS Container ON Container.Id = tmpMIFloat_ContainerId.ContainerId
                                       GROUP BY MovementItem.Id, MovementItem.ParentID, Container.ParentId, Container.Id
                                       )
         , REMAINS AS ( --�������
                       SELECT Container.Id
                            , Container.ObjectId --�����
                            , Container.Amount - COALESCE(tmpMI_Child_ContainerId.Amount, 0) AS Amount  --���. �������
                       FROM Container
                            INNER JOIN tmpMI_Master ON tmpMI_Master.ObjectId = Container.ObjectId
                            LEFT JOIN tmpMI_Child_ContainerId ON tmpMI_Child_ContainerId.ContainerId = Container.Id
                            LEFT JOIN ContainerlinkObject AS ContainerLinkObject_DivisionParties
                                                          ON ContainerLinkObject_DivisionParties.Containerid = Container.Id
                                                         AND ContainerLinkObject_DivisionParties.DescId = zc_ContainerLinkObject_DivisionParties()                                                              
                            LEFT JOIN ObjectBoolean AS ObjectBoolean_BanFiscalSale
                                                    ON ObjectBoolean_BanFiscalSale.ObjectId = ContainerLinkObject_DivisionParties.ObjectId
                                                   AND ObjectBoolean_BanFiscalSale.DescId = zc_ObjectBoolean_DivisionParties_BanFiscalSale()                                                          
                       WHERE Container.DescID = zc_Container_Count()
                         AND Container.WhereObjectId = vbUnitId
                         --AND Container.ObjectId in (SELECT DISTINCT tmpMI_Master.ObjectId FROM tmpMI_Master)
                         AND Container.Amount - COALESCE(tmpMI_Child_ContainerId.Amount, 0) > 0
                         AND (vbisBanFiscalSale = False OR vbisBanFiscalSale = True AND COALESCE (ObjectBoolean_BanFiscalSale.ValueData, False) = True)
                       )
          , DD AS (SELECT tmpMI_Master.ID     AS MovementItemId
                        , tmpMI_Master.Amount
                        , REMAINS.Amount      AS ContainerAmount
                        , REMAINS.Id          AS ContainerId
                        , SUM(REMAINS.Amount) OVER (PARTITION BY REMAINS.objectid ORDER BY Movement.OPERDATE, REMAINS.Id)
                   FROM REMAINS
                        JOIN tmpMI_Master ON tmpMI_Master.objectid = REMAINS.objectid
                        JOIN containerlinkobject AS CLI_MI
                                                 ON CLI_MI.containerid = REMAINS.Id
                                                AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                        JOIN containerlinkobject AS CLI_Unit
                                                 ON CLI_Unit.containerid = REMAINS.Id
                                                AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                                AND CLI_Unit.ObjectId = vbUnitId
                        JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                        JOIN movementitem ON movementitem.Id = Object_PartionMovementItem.ObjectCode
                        JOIN Movement ON Movement.Id = movementitem.movementid
                    WHERE REMAINS.Amount > 0)
          , tmpMIContainerAll AS (SELECT
                                         NULL::Integer    AS ID
                                       , DD.ContainerId
                                       , NULL::Integer    AS ContainerPDId
                                       , DD.MovementItemId
                                       , CASE
                                           WHEN DD.Amount - DD.SUM > 0 THEN DD.ContainerAmount
                                           ELSE DD.Amount - DD.SUM + DD.ContainerAmount
                                         END AS Amount
                                   FROM DD
                                   WHERE (DD.Amount - (DD.SUM - DD.ContainerAmount) > 0)
                                   UNION ALL
                                   SELECT tmpMI_Child_ContainerId.MovementItemId
                                        , tmpMI_Child_ContainerId.ContainerId
                                        , tmpMI_Child_ContainerId.ContainerPDId
                                        , tmpMI_Child_ContainerId.ParentID
                                        , tmpMI_Child_ContainerId.Amount
                                   FROM tmpMI_Child_ContainerId
                                        )
          , tmpContainerPD AS (SELECT Container.ParentId                                          AS ContainerId
                                    , Max(Container.Id)                                           AS ContainerPDId
                               FROM (SELECT DISTINCT tmpMIContainerAll.ContainerId FROM tmpMIContainerAll) AS ContainerAll
                                    INNER JOIN Container ON Container.DescId = zc_Container_CountPartionDate()
                                                        AND Container.WhereObjectId = vbUnitId
                                                        AND Container.ParentId = ContainerAll.ContainerId 
                                                        AND Container.Amount > 0
                               GROUP BY Container.ParentId)
          , tmpContainerPDDate AS (SELECT ContainerAll.ContainerPDId                                        AS ContainerPDId
                                        , ObjectDate_Value.ValueData                                        AS ExpirationDate
                                   FROM (SELECT DISTINCT tmpMI_Child_ContainerId.ContainerPDId FROM tmpMI_Child_ContainerId) AS ContainerAll
                                        LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                      ON CLO_PartionGoods.ContainerId = ContainerAll.ContainerPDId
                                                                     AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                        LEFT OUTER JOIN ObjectDate AS ObjectDate_Value
                                                                   ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                  AND ObjectDate_Value.DescId   =  zc_ObjectDate_PartionGoods_Value()
                                   )
         , tmpContainer AS (SELECT tmp.ContainerId
                                 , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId) AS MovementId_Income
                                 , COALESCE (ObjectDate_Value.ValueData, MIDate_ExpirationDate.ValueData, zc_DateEnd())  AS ExpirationDate
                                 , CASE WHEN ObjectDate_Value.ValueData <= vbDate_0 AND
                                             COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                              THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 ��� (��������� ��� �������)
                                        WHEN ObjectDate_Value.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- ����������
                                        WHEN ObjectDate_Value.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- ������ 1 ������
                                        WHEN ObjectDate_Value.ValueData <= vbDate_3  THEN zc_Enum_PartionDateKind_3()      -- ������ 3 ������
                                        WHEN ObjectDate_Value.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- ������ 6 ������
                                        WHEN ObjectDate_Value.ValueData > vbDate_6   THEN zc_Enum_PartionDateKind_Good()  END  AS PartionDateKindId                              -- ����������� � ���������
                            FROM (SELECT DISTINCT tmpMIContainerAll.ContainerId FROM tmpMIContainerAll) AS tmp

                                 LEFT JOIN tmpContainerPD ON tmpContainerPD.ContainerId = tmp.ContainerId

                                 LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                               ON CLO_PartionGoods.ContainerId = tmpContainerPD.ContainerPDId
                                                              AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                 LEFT OUTER JOIN ObjectDate AS ObjectDate_Value
                                                            ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                           AND ObjectDate_Value.DescId   =  zc_ObjectDate_PartionGoods_Value()
                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                         ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = CLO_PartionGoods.ObjectId
                                                        AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()

                                 LEFT JOIN ContainerlinkObject AS CLO_MovementItem
                                                               ON CLO_MovementItem.Containerid = tmp.ContainerId
                                                              AND CLO_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                 LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_MovementItem.ObjectId
                                 -- ������� �������
                                 LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                 -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                                 LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                             ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                            AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                 -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                                 LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                                 LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                                   ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                                  AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                           )
          --
         , tmpPartion AS (SELECT Movement.Id
                               , MovementDate_Branch.ValueData    AS BranchDate
                               , Movement.Invnumber               AS Invnumber
                               , MovementLinkObject_From.ObjectId AS FromId
                               , Object_From.ValueData            AS FromName
                               , Object_Contract.ValueData       AS ContractName
                          FROM Movement
                               LEFT JOIN MovementDate AS MovementDate_Branch
                                                      ON MovementDate_Branch.MovementId = Movement.Id
                                                     AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                               LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                               LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
                          WHERE Movement.Id IN (SELECT DISTINCT tmpContainer.MovementId_Income FROM tmpContainer)
                          )
         , tmpContainerTo AS (SELECT Container.ObjectId                                          AS ObjectId
                                   , MovementLinkObject_From.ObjectId                            AS FromId
                              FROM (SELECT DISTINCT MovementItem.ObjectId
                                    FROM MovementItem
                                    WHERE MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId = zc_MI_Master()
                                    --   AND MovementItem.Amount > 0
                                       AND MovementItem.isErased = FALSE
                                       ) AS tmpMI
                                   INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                                       AND Container.WhereObjectId in (SELECT OL_Unit_Juridical.ObjectId FROM ObjectLink AS OL_Unit_Juridical
                                                                                       WHERE OL_Unit_Juridical.ChildObjectId = vbJuridicalId
                                                                                         AND OL_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical())
                                                       AND Container.ObjectId = tmpMI.ObjectId

                                   LEFT JOIN MovementItemContainer AS MIC
                                                                   ON MIC.Containerid = Container.Id
                                                                  AND MIC.MovementDescId = zc_Movement_Income()
                                                                  AND MIC.OperDate >= vbOperDate - INTERVAL '30 MONTH'
                                                                  AND MIC.OperDate < vbOperDate

                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                ON MovementLinkObject_From.MovementId = MIC.MovementId
                                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                               GROUP BY Container.ObjectId
                                      , MovementLinkObject_From.ObjectId
                               )

         SELECT
               Container.ID::Integer      AS ID
             , MovementItem.Id            AS ParentId
             , MovementItem.ObjectId      AS GoodsId
--             , Object_Goods.ObjectCode    AS GoodsCode
  --           , Object_Goods.ValueData     AS GoodsName
             , Container.Amount::TFloat   AS Amount

             , COALESCE (Container.ContainerPDId, Container.ContainerId)  :: TFloat      AS ContainerId
             , COALESCE (tmpContainerPDDate.ExpirationDate, tmpContainer.ExpirationDate, NULL)  :: TDateTime   AS ExpirationDate
             , COALESCE (tmpPartion.BranchDate, NULL)            :: TDateTime   AS OperDate_Income
             , COALESCE (tmpPartion.Invnumber, NULL)             :: TVarChar    AS Invnumber_Income
             , COALESCE (tmpPartion.FromName, NULL)              :: TVarChar    AS FromName_Income
             , COALESCE (tmpPartion.ContractName, NULL)          :: TVarChar    AS ContractName_Income

             , Object_PartionDateKind.ValueData                  :: TVarChar    AS PartionDateKindName
             , DATE_TRUNC ('DAY', MIDate_Insert.ValueData)       :: TDateTime   AS DateInsert
             , CASE WHEN COALESCE(Container.ID, 0) = 0 THEN FALSE ELSE TRUE END AS PartyRelated

             --, CASE WHEN COALESCE(tmpContainerTo.ObjectId, 0) <> 0 THEN zc_Color_Black() ELSE zc_Color_Red() END  AS Color_calc
             , zc_Color_Black() AS Color_calc
             , MovementItem.isErased                                            AS isErased
         FROM tmpMIContainerAll AS Container

              LEFT JOIN tmpMI_Master AS MovementItem ON MovementItem.ID = Container.MovementItemId

--              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

              LEFT JOIN tmpContainer ON tmpContainer.ContainerId = Container.ContainerId
              LEFT JOIN tmpContainerPDDate ON tmpContainerPDDate.ContainerPDId = Container.ContainerPDId
              LEFT JOIN tmpPartion ON tmpPartion.Id= tmpContainer.MovementId_Income
              LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = tmpContainer.PartionDateKindId
              LEFT OUTER JOIN MovementItemDate  AS MIDate_Insert
                                                ON MIDate_Insert.MovementItemId = MovementItem.Id
                                               AND MIDate_Insert.DescId = zc_MIDate_Insert()
              /*LEFT OUTER JOIN tmpContainerTo ON tmpContainerTo.ObjectId = MovementItem.ObjectId
                                            AND tmpContainerTo.FromId = tmpPartion.FromId*/
         ;

     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.06.19         *
*/

-- ����
-- 

select * from gpSelect_MovementItem_Send_Child(inMovementId := 32815662 ,  inSession := '3');

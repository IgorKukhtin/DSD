-- Function: gpSelect_MovementItem_Loss_Child()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Loss_Child (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Loss_Child(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId integer
             , Amount TFloat
             , ContainerId TFloat
             , ExpirationDate      TDateTime
             , OperDate_Income     TDateTime
             , Invnumber_Income    TVarChar
             , FromName_Income     TVarChar
             , ContractName_Income TVarChar
             , PartionDateKindName TVarChar
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

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Send());
    vbUserId := inSession;

    -- параметры документа
    SELECT Movement.OperDate
         , Movement.StatusID
    INTO vbOperDate
       , vbStatusID
    FROM Movement
    WHERE Movement.Id = inMovementId;

    -- значения для разделения по срокам
    SELECT Date_6, Date_3, Date_1, Date_0
    INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
    FROM lpSelect_PartionDateKind_SetDate ();

     -- Для проведенных и отложенных показываем что реально провелось

     RETURN QUERY
     WITH
         tmpMIContainerPD AS (SELECT MovementItemContainer.MovementItemID     AS Id
                                   , Container.Id                             AS ContainerId
                                   , Container.ParentId                       AS ParentId
                                   , MovementItemContainer.Amount             AS Amount
                               FROM  MovementItemContainer

                                     INNER JOIN Container ON Container.ID = MovementItemContainer.ContainerID

                               WHERE MovementItemContainer.MovementId = inMovementId
                                 AND MovementItemContainer.DescId = zc_Container_CountPartionDate()
                               )
       , tmpMIContainerAll AS ( SELECT MovementItemContainer.MovementItemID      AS MovementItemId
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
                                   AND (- MovementItemContainer.Amount - COALESCE(tmpMIContainerPD.Amount, 0)) <> 0
                                 )
       , tmpContainer AS (SELECT tmp.MovementItemID
                               , tmp.ContainerId
                               , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId) AS MovementId_Income
                               , COALESCE (ObjectDate_Value.ValueData, MIDate_ExpirationDate.ValueData, zc_DateEnd())  AS ExpirationDate
                               , tmp.Amount
                               , CASE WHEN ObjectDate_Value.ValueData <= vbDate_0 AND
                                           COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                   THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 кат (просрочка без наценки)
                                      WHEN ObjectDate_Value.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- просрочено
                                      WHEN ObjectDate_Value.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- Меньше 1 месяца
                                      WHEN ObjectDate_Value.ValueData <= vbDate_3  THEN zc_Enum_PartionDateKind_3()      -- Меньше 3 месяца
                                      WHEN ObjectDate_Value.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- Меньше 6 месяца
                                      WHEN ObjectDate_Value.ValueData > vbDate_6   THEN zc_Enum_PartionDateKind_Good()  END  AS PartionDateKindId                              -- Востановлен с просрочки
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
                               -- элемент прихода
                               LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                               -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                               LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                           ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                          AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                               -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
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

       SELECT
             Container.ContainerId                                          AS ID
           , Container.MovementItemID                                       AS ParentId
           , Container.Amount::TFloat   AS Amount

           , Container.ContainerId:: TFloat                                 AS ContainerId
           , COALESCE (Container.ExpirationDate, NULL)        :: TDateTime  AS ExpirationDate
           , COALESCE (tmpPartion.BranchDate, NULL)           :: TDateTime  AS OperDate_Income
           , COALESCE (tmpPartion.Invnumber, NULL)            :: TVarChar   AS Invnumber_Income
           , COALESCE (tmpPartion.FromName, NULL)             :: TVarChar   AS FromName_Income
           , COALESCE (tmpPartion.ContractName, NULL)         :: TVarChar   AS ContractName_Income

           , Object_PartionDateKind.ValueData                  :: TVarChar  AS PartionDateKindName

       FROM tmpContainer AS Container

            LEFT JOIN tmpPartion ON tmpPartion.Id = Container.MovementId_Income
            LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = Container.PartionDateKindId
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.02.22                                                       *
*/

-- тест


select * from gpSelect_MovementItem_Loss_Child(inMovementId := 26650132  ,  inSession := '3');
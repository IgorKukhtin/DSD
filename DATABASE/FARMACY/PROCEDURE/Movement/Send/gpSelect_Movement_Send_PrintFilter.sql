-- Function: gpSelect_Movement_Send_PrintFilter()

DROP FUNCTION IF EXISTS gpSelect_Movement_Send_PrintFilter (Text, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Send_PrintFilter(
    IN inDataJson      Text      , -- json Данные  
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , MovementItemId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , MeasureName TVarChar
             , Amount TFloat
             , AccommodationName TVarChar
             , MinExpirationDate TDateTime
              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= inSession;

     IF inDataJson = '[]'
     THEN
       RAISE EXCEPTION 'Данные с базы не загружены.';
     END IF;

      
     -- из JSON в таблицу
     CREATE TEMP TABLE tblDataJSON
     (
        Id              Integer
     ) ON COMMIT DROP;

     INSERT INTO tblDataJSON
     SELECT *
     FROM json_populate_recordset(null::tblDataJSON, replace(replace(replace(inDataJson, '&quot;', '\"'), CHR(9),''), CHR(10),'')::json);
     
     
     CREATE TEMP TABLE tmpMovement ON COMMIT DROP AS
     SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName
           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , Object_From.Id                                     AS FromId
           , Object_From.ValueData                              AS FromName
           , Object_To.Id                                       AS ToId
           , Object_To.ValueData                                AS ToName
           , COALESCE (MovementBoolean_Deferred.ValueData, FALSE) ::Boolean  AS isDeferred
       FROM tblDataJSON 
       
            INNER JOIN Movement ON Movement.ID = tblDataJSON.Id
                               AND Movement.DescId = zc_Movement_Send() 
            
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                      ON MovementBoolean_Deferred.MovementId = Movement.Id
                                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
      ;     
      
      ANALYSE tmpMovement;
      
      CREATE TEMP TABLE tmpMI_Child_Report (ParentId Integer, ExpirationDate TDateTime)  ON COMMIT DROP;
      
      INSERT INTO  tmpMI_Child_Report
      (SELECT MI_Child.ParentId
            , MIN(COALESCE (MI_Child.ExpirationDate, zc_DateEnd()))  AS ExpirationDate
       FROM tmpMovement
                           
            LEFT JOIN gpSelect_MovementItem_Send_Child(inMovementId := tmpMovement.Id,  inSession := inSession) AS MI_Child ON 1 = 1
                                
       GROUP BY MI_Child.ParentId
      );
      
     ANALYSE tmpMI_Child_Report;
     
     CREATE TEMP TABLE MovementItem_Send ON COMMIT DROP AS 
                                (SELECT MovementItem.Id
                                      , MovementItem.MovementId
                                      , MovementItem.ObjectId
                                      , MovementItem.ParentId
                                      , MovementItem.Amount
                                      , Movement.FromId
                                      , Movement.ToId
                                      , Movement.isDeferred
                                 FROM tmpMovement AS Movement
                                      INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                             AND MovementItem.DescId = zc_MI_Master()
                                                             AND MovementItem.isErased = FALSE
                                                             AND MovementItem.Amount > 0
                                );
                                
     ANALYSE MovementItem_Send;


     CREATE TEMP TABLE tmpMI ON COMMIT DROP AS (
     WITH
           tmpContainer AS (SELECT Container.Id
                                 , Container.ObjectId         AS GoodsId
                                 , Container.WhereObjectId    AS UnitId
                                 , Object_PartionMovementItem.ObjectCode ::Integer AS MI_Id
                            FROM (SELECT DISTINCT MovementItem_Send.ObjectId
                                       , MovementItem_Send.FromId    
                                  FROM MovementItem_Send) AS MovementItem_Send
                                   
                                INNER JOIN Container ON Container.ObjectId = MovementItem_Send.ObjectId
                                                    AND Container.WhereObjectId = MovementItem_Send.FromId
                                                    AND Container.DescId = zc_Container_Count()
                                                    AND Container.Amount <> 0
 
                                INNER JOIN ContainerLinkObject AS CLI_MI 
                                                               ON CLI_MI.ContainerId = Container.Id
                                                              AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                INNER JOIN OBJECT AS Object_PartionMovementItem 
                                                  ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                             
                            GROUP BY Container.ObjectId
                                   , Container.WhereObjectId
                                   , Object_PartionMovementItem.ObjectCode, Container.Id
                            )

         , tmpMinExpirationDate AS (SELECT tmpContainer.GoodsId
                                         , tmpContainer.UnitId
                                         , MIN(COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate -- Срок годности
                                    FROM tmpContainer
                                         INNER JOIN MovementItem ON MovementItem.Id = tmpContainer.MI_Id
                                         LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                                           ON MIFloat_Price.MovementItemId = MovementItem.ID
                                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                         -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                         LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                               AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                         -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                         LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                                         LEFT JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MovementItem.Id) 
                                               AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                     GROUP BY tmpContainer.GoodsId
                                            , tmpContainer.UnitId
                                    )

         , tmpMIContainerSend AS (SELECT COALESCE(MISend.ParentID, MIContainer_Count.MovementItemId) AS MovementItemId
                                       , COALESCE (MI_Income_find.Id,MovementItem.Id) AS MIIncomeId
                                  FROM MovementItem_Send
                                  
                                       INNER JOIN MovementItemContainer AS MIContainer_Count 
                                                                        ON MIContainer_Count.MovementItemId = MovementItem_Send.Id
                                                                       AND MIContainer_Count.MovementId = MovementItem_Send.MovementId 
                                                                       AND MIContainer_Count.DescId = zc_Container_Count()
                                                                       AND MIContainer_Count.isActive = False
                                 
                                        -- элемент прихода
                                        LEFT OUTER JOIN MovementItem AS MISend
                                                                     ON MISend.Id = MIContainer_Count.MovementItemID
                                                                      
                                        LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                     ON CLI_MI.ContainerId = MIContainer_Count.ContainerId
                                                    AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                        LEFT OUTER JOIN Object AS Object_PartionMovementItem 
                                                     ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                        -- элемент прихода
                                        LEFT OUTER JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode

                                        -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                        LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                               ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                              AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                        -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                        LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
       
                                  )   

         , tmpMIContainer AS (SELECT MIContainer_Count.MovementItemId           AS MovementItemId
                                   , MIN (COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate -- Срок годности
                              FROM tmpMIContainerSend AS MIContainer_Count
                                   LEFT JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                               ON MIDate_ExpirationDate.MovementItemId = MIContainer_Count.MIIncomeId 
                                                              AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                               GROUP BY MIContainer_Count.MovementItemId
                              )
                                 

       SELECT
             MovementItem.Id                    AS Id
           , MovementItem.MovementId            AS MovementId
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , Object_Measure.ValueData           AS MeasureName
           , MovementItem.Amount                AS Amount
           , Object_Accommodation.ValueData     AS AccommodationName
           , COALESCE (tmpMI_Child.ExpirationDate, tmpMIContainer.MinExpirationDate, tmpMinExpirationDate.MinExpirationDate, zc_DateEnd() )::TDateTime AS MinExpirationDate
       FROM MovementItem_Send AS MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT OUTER JOIN AccommodationLincGoods AS Accommodation
                                                   ON Accommodation.UnitId = MovementItem.FromId
                                                  AND Accommodation.GoodsId = Object_Goods.Id
                                                  AND Accommodation.isErased = False
            -- Размещение товара
            LEFT JOIN Object AS Object_Accommodation  ON Object_Accommodation.ID = Accommodation.AccommodationId
            
            LEFT JOIN tmpMI_Child_Report AS tmpMI_Child ON tmpMI_Child.ParentId = MovementItem.Id
            LEFT JOIN tmpMIContainer ON tmpMIContainer.MovementItemId = MovementItem.Id
            LEFT JOIN tmpMinExpirationDate ON tmpMinExpirationDate.GoodsId = MovementItem.ObjectId
            
       ORDER BY MovementItem.MovementId, Object_Goods.ValueData
       ) ;
       
    ANALYSE tmpMI;
    

    RETURN QUERY
    SELECT
           Movement.Id                                        AS Id
         , Movement.InvNumber                                 AS InvNumber
         , Movement.OperDate                                  AS OperDate
         , Movement.StatusCode
         , Movement.StatusName
         , Movement.TotalCount
         , Movement.FromId
         , Movement.FromName
         , Movement.ToId
         , Movement.ToName
         
         , MovementItem.Id                    AS MovementItemId
         , MovementItem.GoodsId
         , MovementItem.GoodsCode
         , MovementItem.GoodsName
         , MovementItem.MeasureName
         , MovementItem.Amount
         , MovementItem.AccommodationName
         , MovementItem.MinExpirationDate
     FROM tmpMovement AS Movement
     
          LEFT JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id
     
     ORDER BY Movement.Id, MovementItem.GoodsName;
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Send_PrintFilter (Text,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А
 22.01.20         *
 29.07.15                                                                       *
*/

-- 
select * from gpSelect_Movement_Send_PrintFilter(inDataJson := '[{"id":30706121},{"id":30706123},{"id":30706124},{"id":30706125},{"id":30706127},{"id":30706128},{"id":30706129},{"id":30706130},{"id":30706131}]' ,  inSession := '3');




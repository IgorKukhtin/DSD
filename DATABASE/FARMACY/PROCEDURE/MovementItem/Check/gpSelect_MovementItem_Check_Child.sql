-- Function: gpSelect_MovementItem_Check_Child()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Check_Child (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Check_Child(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , ContainerId TFloat
             , ExpirationDate      TDateTime
             , OperDate_Income     TDateTime
             , Invnumber_Income    TVarChar
             , FromName_Income     TVarChar
             , ContractName_Income TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Check());
     vbUserId := inSession;

     RETURN QUERY
     WITH
     tmpMI_Child AS (SELECT MovementItem.*
                     FROM MovementItem
                     WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId = zc_MI_Child()
                     )

   , tmpContainerAll AS (SELECT tmp.Id
                              , MIFloat_ContainerId.ValueData :: Integer AS ContainerId
                              , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId) AS MovementId_Income
                              , COALESCE (MI_Income_find.Id,MI_Income.Id)                 AS MIId_Income
                              , ContainerLinkObject.ObjectId                              AS PartionGoodsId
                      FROM tmpMI_Child AS tmp
                      
                           INNER JOIN MovementItemFloat AS MIFloat_ContainerId
                                                        ON MIFloat_ContainerId.MovementItemId = tmp.Id
                                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                           
                           LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                         ON ContainerLinkObject_MovementItem.Containerid = MIFloat_ContainerId.ValueData :: Integer
                                                        AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                           LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                           -- элемент прихода
                           LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                           -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                           LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                       ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                      AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                           -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                           LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                                      
                           LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = MIFloat_ContainerId.ValueData :: Integer
                                                        AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()


                     )
    --
   , tmpContainer AS (SELECT tmp.Id
                           , tmp.ContainerId
                           , tmp.MovementId_Income                                                                          AS MovementId_Income
                           , COALESCE (ObjectDate_ExpirationDate.ValueData, MIDate_ExpirationDate.ValueData, zc_DateEnd())  AS ExpirationDate
                      FROM tmpContainerAll AS tmp
                                      
                           LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                             ON MIDate_ExpirationDate.MovementItemId = tmp.MIId_Income
                                                            AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                                            
                           LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                ON ObjectDate_ExpirationDate.ObjectId = tmp.PartionGoodsId
                                               AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()


                     )
    --
   , tmpPartion AS (SELECT Movement.Id
                         , MovementDate_Branch.ValueData AS BranchDate
                         , Movement.Invnumber            AS Invnumber
                         , Object_From.ValueData         AS FromName
                         , Object_Contract.ValueData     AS ContractName
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
             MovementItem.Id
           , MovementItem.ParentId  
           , Object_Goods.Id            AS GoodsId
           , Object_Goods.ObjectCode    AS GoodsCode
           , Object_Goods.ValueData     AS GoodsName
           , MovementItem.Amount

           , tmpContainer.ContainerId                          :: TFloat    AS ContainerId
           , COALESCE (tmpContainer.ExpirationDate, NULL)      :: TDateTime AS ExpirationDate
           , COALESCE (tmpPartion.BranchDate, NULL)            :: TDateTime AS OperDate_Income
           , COALESCE (tmpPartion.Invnumber, NULL)             :: TVarChar  AS Invnumber_Income
           , COALESCE (tmpPartion.FromName, NULL)              :: TVarChar  AS FromName_Income
           , COALESCE (tmpPartion.ContractName, NULL)          :: TVarChar  AS ContractName_Income

       FROM tmpMI_Child AS MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN tmpContainer ON tmpContainer.Id = MovementItem.Id
            LEFT JOIN tmpPartion ON tmpPartion.Id= tmpContainer.MovementId_Income
       ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.06.19         *
*/

-- тест
-- select * from gpSelect_MovementItem_Check_Child(inMovementId := 3959328 ,  inSession := '3'
select * from gpSelect_MovementItem_Check_Child(inMovementId := 22245296 ,  inSession := '3');
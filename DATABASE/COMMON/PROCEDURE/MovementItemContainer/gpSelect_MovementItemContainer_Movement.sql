-- Function: gpSelect_MovementItemContainer_Movement()

--DROP FUNCTION gpSelect_MovementItemContainer_Movement();

-- Запрос возвращает все проводки по документу

CREATE OR REPLACE FUNCTION gpSelect_MovementItemContainer_Movement(
IN inMovementId          Integer,       /* Документ */
IN inSession             TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Login TVarChar, Password TVarChar, isErased boolean) AS
$BODY$BEGIN

--   PERFORM lpCheckRight(inSession, zc_Object_Process_User());

RETURN QUERY 
      SELECT 
             MovementItemContainer.Amount,
             MovementItemContainer.ContainerId,
             Object.ValueData                 AS ObjectName,
             Object.ObjectCode                AS ObjectCode,
             ContainerLinkObjectDesc.ItemName AS AnalyticName
        FROM MovementItemContainer
        JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = MovementItemContainer.ContainerId
        JOIN Object ON Object.Id = ContainerLinkObject.ObjectId
        JOIN ContainerLinkObjectDesc ON ContainerLinkObject.DescId = ContainerLinkObjectDesc.Id
       WHERE MovementItemContainer.MovementId = inMovementId;
     
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpSelect_MovementItemContainer_Movement(Integer, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_MovementItemContainer_Movement('2')
-- Function: gpComplete_SelectAll_Sybase_ALL()

DROP FUNCTION IF EXISTS gpComplete_SelectAll_Sybase (TDateTime, TDateTime, Boolean, Boolean);

CREATE OR REPLACE FUNCTION gpComplete_SelectAll_Sybase(
    IN inStartDate          TDateTime , -- 
    IN inEndDate            TDateTime , --
    IN inIsSale             Boolean   , -- 
    IN inIsBefoHistoryCost  Boolean
)                              
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, Code TVarChar, ItemName TVarChar
              )
AS
$BODY$
BEGIN
     -- !!!Замена!!!
     IF inIsSale = TRUE
     THEN 
         inIsBefoHistoryCost:= FALSE;
     END IF;


     -- Результат
     RETURN QUERY 
     SELECT tmp.MovementId
          , tmp.OperDate
          , tmp.InvNumber
          , tmp.Code
          , tmp.ItemName
     FROM (
     -- 1.1. From: Sale + !!!NOT SendOnPrice!!!
     SELECT DISTINCT
            Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
     FROM ContainerLinkObject AS CLO_Member
                  INNER JOIN MovementItemContainer AS MIContainer
                                                   ON MIContainer.ContainerId = CLO_Member.ContainerId
                                                  AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                  AND MIContainer.DescId = zc_MIContainer_Summ()
                                                  AND MIContainer.Amount <> 0
                  LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
                  LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

                  LEFT JOIN ContainerLinkObject AS CLO_Goods
                                                ON CLO_Goods.ContainerId = CLO_Member.ContainerId
                                               AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()

          LEFT JOIN Object AS Object_From ON Object_From.Id = MIContainer.ObjectId_Analyzer
          LEFT JOIN Object AS Object_To ON Object_To.Id = MIContainer.ObjectExtId_Analyzer

             WHERE CLO_Member.DescId = zc_ContainerLinkObject_Member()
               AND CLO_Goods.ContainerId IS NULL
               AND Movement.DescId <> zc_Movement_Income()

    ) AS tmp
    -- WHERE tmp.MovementId >= 2212722 OR tmp.Code = 'zc_Movement_Inventory'
    ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 10.04.16                                        *
*/

-- тест
-- SELECT * FROM gpComplete_SelectAll_Sybase (inStartDate:= '01.01.2016', inEndDate:= '31.01.2016', inIsSale:= TRUE, inIsBefoHistoryCost:= TRUE)

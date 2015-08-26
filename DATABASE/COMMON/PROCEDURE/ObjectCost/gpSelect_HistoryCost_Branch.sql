-- Function: gpSelect_HistoryCost_Branch()

DROP FUNCTION IF EXISTS gpSelect_HistoryCost_Branch (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_HistoryCost_Branch(
    IN inStartDate       TDateTime , --
    IN inEndDate         TDateTime , --
    IN inSession         TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (StartDate TDateTime, EndDate TDateTime, BranchId Integer, BranchCode Integer, BranchName TVarChar)
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_InsertUpdate_HistoryCost());



     RETURN QUERY
     WITH tmpBranch AS (SELECT Object.Id AS BranchId FROM Object WHERE Object.DescId = zc_Object_Branch() AND Object.Id IN (8374, 301310) AND Object.isErased = FALSE) -- филиал Одесса + филиал Запорожье
        , tmpList AS (SELECT Movement.OperDate, ObjectLink_ObjectFrom_Branch.ChildObjectId AS BranchId
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                           INNER JOIN ObjectLink AS ObjectLink_ObjectFrom_Branch
                                                ON ObjectLink_ObjectFrom_Branch.ObjectId = MovementLinkObject_From.ObjectId
                                               AND ObjectLink_ObjectFrom_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                               -- AND ObjectLink_ObjectFrom_Branch.ChildObjectId <> zc_Branch_Basis()
                          INNER JOIN tmpBranch ON tmpBranch.BranchId = ObjectLink_ObjectFrom_Branch.ChildObjectId
                      WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                        AND Movement.DescId = zc_Movement_Inventory()
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                      GROUP BY Movement.OperDate, ObjectLink_ObjectFrom_Branch.ChildObjectId
                     )
        , tmpList_min AS (SELECT tmpList.BranchId, MIN (tmpList.OperDate) AS OperDate FROM tmpList GROUP BY tmpList.BranchId)

      SELECT tmp.StartDate  :: TDateTime AS StartDate
           , tmp.EndDate    :: TDateTime AS EndDate
           , tmp.BranchId
           , Object_Branch.ObjectCode AS BranchCode
           , Object_Branch.ValueData  AS BranchName
      FROM (SELECT tmpList_min.BranchId  AS BranchId
                 , inStartDate           AS StartDate
                 , tmpList_min.OperDate  AS EndDate
            FROM tmpList_min
           UNION
            SELECT tmpList.BranchId  AS BranchId
                 , tmpList.OperDate + INTERVAL '1 DAY' AS StartDate
                 , CASE WHEN inEndDate > (SELECT MIN (tmpList_next.OperDate) FROM tmpList AS tmpList_next WHERE tmpList_next.BranchId = tmpList.BranchId AND tmpList_next.OperDate > tmpList.OperDate)
                             THEN (SELECT MIN (tmpList_next.OperDate) FROM tmpList AS tmpList_next WHERE tmpList_next.BranchId = tmpList.BranchId AND tmpList_next.OperDate > tmpList.OperDate)
                        ELSE inEndDate
                   END AS EndDate
            FROM tmpList
            WHERE tmpList.OperDate < inEndDate
           UNION
            SELECT tmpBranch.BranchId  AS BranchId
                 , inStartDate         AS StartDate
                 , inEndDate           AS EndDate
            FROM tmpBranch
                 LEFT JOIN tmpList ON tmpList.BranchId = tmpBranch.BranchId
            WHERE tmpList.BranchId IS NULL
           ) AS tmp
           LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmp.BranchId
      ORDER BY tmp.StartDate, Object_Branch.ObjectCode
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.08.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_HistoryCost_Branch (inStartDate:= '01.07.2015', inEndDate:= '31.07.2015', inSession:= '2') ORDER BY 4, 1

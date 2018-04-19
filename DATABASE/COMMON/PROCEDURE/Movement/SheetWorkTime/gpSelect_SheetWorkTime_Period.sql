-- Function: gpSelect_SheetWorkTime_Period()

-- DROP FUNCTION IF EXISTS gpSelect_SheetWorkTime_Period (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_SheetWorkTime_Period (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_SheetWorkTime_Period(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer   , -- ��. ��.����
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (OperDate TDateTime, UnitId Integer, UnitName TVarChar, isComplete Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMemberId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_SheetWorkTime());
     vbUserId:= lpGetUserBySession (inSession);


     -- ����� ���������
     IF EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin(), 14473, 447972)) -- �������� ���� ������������ + �������� ��
     THEN vbMemberId:= 0;
     ELSE
         vbMemberId:= (SELECT ObjectLink_User_Member.ChildObjectId
                       FROM ObjectLink AS ObjectLink_User_Member
                       WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                         AND ObjectLink_User_Member.ObjectId = vbUserId
                         AND vbUserId NOT IN (/*439994 -- ������ �.�.
                                            , */
                                              300527  -- ����������� �.�.
                                            , 1147527 -- ���������� �.�.
                                            , 439923  -- ��������� �.�.
                                            , 439925  -- ������� �.�.
                                            , 1998523 -- ��������� �.�.
                                             )
                      UNION
                       SELECT ObjectLink_User_Member.ChildObjectId
                       FROM ObjectLink AS ObjectLink_User_Member
                       WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                         AND ObjectLink_User_Member.ObjectId = CASE /*WHEN vbUserId = 439994 -- ������ �.�.
                                                                         THEN 439613 -- ��������� �.�.*/
                                                                    WHEN vbUserId IN (300527  -- ����������� �.�.
                                                                                    , 1147527 -- ���������� �.�.
                                                                                     )
                                                                         THEN 300523 -- ������� �.�.
                                                                    WHEN vbUserId IN (439923, 439925) -- ��������� �.�. + ������� �.�.
                                                                         THEN 439917 -- ��������� �.�.
                                                                    WHEN vbUserId = 1998523 -- ��������� �.�.
                                                                         -- THEN 1998663  -- ������ �.�.
                                                                         THEN 929721 -- �������� �.�.
                                                               END
                         AND vbUserId IN (439994  -- ������ �.�.
                                        , 300527  -- ����������� �.�.
                                        , 1147527 -- ���������� �.�.
                                        , 439923  -- ��������� �.�.
                                        , 439925  -- ������� �.�.
                                        , 1998523 -- ��������� �.�.
                                         )
                      );
     END IF;


     -- ������ ����� ������
     vbStartDate := DATE_TRUNC ('MONTH', inStartDate);
     -- ��������� ����� ������
     vbEndDate := DATE_TRUNC ('MONTH', inEndDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';


     -- ���������
     RETURN QUERY 
       WITH tmpList AS (SELECT DISTINCT ObjectLink.ObjectId AS UnitId
                        FROM ObjectLink
                             LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                  ON ObjectLink_Personal_Member.ObjectId = ObjectLink.ChildObjectId
                                                 AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                        WHERE ObjectLink.DescId = zc_ObjectLink_Unit_PersonalSheetWorkTime()
                          AND (ObjectLink_Personal_Member.ChildObjectId = vbMemberId OR vbMemberId = 0)
                       )
             /*tmpList AS (SELECT DISTINCT Object_Personal_View.UnitId
                        FROM Object_Personal_View
                        WHERE (Object_Personal_View.MemberId = vbMemberId OR vbMemberId = 0)
                       )*/

          , tmpMovement AS (SELECT DISTINCT MovementLinkObject_Unit.ObjectId AS UnitId, DATE_TRUNC ('MONTH', Movement.OperDate) AS OperDate
                            FROM Movement
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                 LEFT JOIN tmpList ON tmpList.UnitId = MovementLinkObject_Unit.ObjectId
                            WHERE Movement.DescId = zc_Movement_SheetWorkTime()
                              AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                              AND (tmpList.UnitId > 0 OR vbMemberId = 0)
                           )
          , tmpPeriod AS (SELECT tmp.OperDate, tmpList.UnitId
                          FROM (SELECT generate_series (vbStartDate, vbEndDate, '1 MONTH' :: INTERVAL) AS OperDate) AS tmp
                               LEFT JOIN tmpList ON 1 =1 
                         )
       -- ���������
       SELECT COALESCE (tmpPeriod.OperDate, tmpMovement.OperDate) :: TDateTime AS OperDate
           , Object_Unit.Id           AS UnitId
           , Object_Unit.ValueData    AS UnitName
           , CASE WHEN tmpMovement.UnitId IS NOT NULL THEN TRUE ELSE FALSE END :: Boolean AS isComplete
       FROM tmpPeriod
            FULL JOIN tmpMovement ON tmpMovement.UnitId   = tmpPeriod.UnitId
                                 AND tmpMovement.OperDate = tmpPeriod.OperDate
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE (tmpPeriod.UnitId, tmpMovement.UnitId)
      ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.10.16         * add inJuridicalBasisId
 23.03.16                                        * all
 01.03.16         * add isComplete
 28.12.13                                        * add zc_ObjectLink_StaffList_Unit
01.10.13         *
*/

-- ����
-- SELECT * FROM gpSelect_SheetWorkTime_Period (inStartDate:= '30.01.2016', inEndDate:= '01.02.2016', inJuridicalBasisId:= 0, inSession:= '5')

-- View: Object_Personal_View

DROP VIEW IF EXISTS Object_Personal_View;

CREATE OR REPLACE VIEW Object_Personal_View AS
  SELECT Object_Personal.Id                        AS PersonalId
       , Object_Personal.DescId
       , ObjectLink_Personal_Member.ChildObjectId  AS MemberId
       , Object_Personal.ObjectCode                AS PersonalCode
       , Object_Personal.ValueData                 AS PersonalName
       , Object_Personal.AccessKeyId               AS AccessKeyId
       , Object_Personal.isErased                  AS isErased

       , COALESCE (ObjectLink_Personal_Position.ChildObjectId, 0) AS PositionId
       , Object_Position.ObjectCode                 AS PositionCode
       , Object_Position.ValueData                  AS PositionName

       , COALESCE (ObjectLink_Personal_Unit.ChildObjectId, 0) AS UnitId
       , Object_Unit.ObjectCode                    AS UnitCode
       , Object_Unit.ValueData                     AS UnitName


 
       , ObjectDate_DateIn.ValueData   AS DateIn
       , ObjectDate_DateOut.ValueData  AS DateOut
       , CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN NULL ELSE ObjectDate_DateOut.ValueData END :: TDateTime AS DateOut_user
       , CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN FALSE ELSE TRUE END AS isDateOut
       , COALESCE (ObjectBoolean_Main.ValueData, FALSE)           AS isMain
       , COALESCE (ObjectBoolean_Official.ValueData, FALSE)       AS isOfficial
         
   FROM Object AS Object_Personal
       LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                            ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id
                           AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
       LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_Personal_Member.ChildObjectId
       LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                            ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                           AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
       LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId
 
       LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                            ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                           AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId
           
       LEFT JOIN ObjectDate AS ObjectDate_DateIn
                            ON ObjectDate_DateIn.ObjectId = Object_Personal.Id
                           AND ObjectDate_DateIn.DescId = zc_ObjectDate_Personal_In()
       LEFT JOIN ObjectDate AS ObjectDate_DateOut
                            ON ObjectDate_DateOut.ObjectId = Object_Personal.Id
                           AND ObjectDate_DateOut.DescId = zc_ObjectDate_Personal_Out()          

       LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                               ON ObjectBoolean_Main.ObjectId = Object_Personal.Id
                              AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Personal_Main()
       LEFT JOIN ObjectBoolean AS ObjectBoolean_Official
                               ON ObjectBoolean_Official.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                              AND ObjectBoolean_Official.DescId = zc_ObjectBoolean_Member_Official()
 WHERE Object_Personal.DescId = zc_Object_Personal();


/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».    œÓÎˇÚ˚ÍËÌ ¿.¿.
 09.05.17                                                          *
 20.01.15                                        * add Branch...
 12.09.14                                        * add isOffical and isDateOut and isMain
 21.05.14                        * add Offical
 08.12.13                                        * add AccessKeyId
 21.11.13                                        * add PositionLevel...
 09.11.13                                        * add DescId
 28.10.13                        *
 30.09.13                                        *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_Personal_View

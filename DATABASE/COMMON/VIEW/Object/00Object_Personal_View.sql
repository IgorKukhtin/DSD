-- View: Object_Personal_View

-- DROP VIEW IF EXISTS Object_Personal_View;

CREATE OR REPLACE VIEW Object_Personal_View AS
  SELECT Object_Personal.Id                        AS PersonalId
       , Object_Personal.DescId
       , ObjectLink_Personal_Member.ChildObjectId  AS MemberId
       , Object_Member.ObjectCode                  AS PersonalCode
       , Object_Member.ValueData                   AS PersonalName
       , Object_Personal.isErased                  AS isErased

       , ObjectLink_Personal_Position.ChildObjectId AS PositionId
       , Object_Position.ObjectCode                 AS PositionCode
       , Object_Position.ValueData                  AS PositionName

       , ObjectLink_Personal_Unit.ChildObjectId    AS UnitId
       , Object_Unit.ObjectCode                    AS UnitCode
       , Object_Unit.ValueData                     AS UnitName

       , ObjectLink_Personal_PersonalGroup.ChildObjectId  AS PersonalGroupId
       , Object_PersonalGroup.ObjectCode                  AS PersonalGroupCode
       , Object_PersonalGroup.ValueData                   AS PersonalGroupName
 
       , ObjectDate_DateIn.ValueData   AS DateIn
       , ObjectDate_DateOut.ValueData  AS DateOut
         
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

       LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                            ON ObjectLink_Personal_PersonalGroup.ObjectId = Object_Personal.Id
                           AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
       LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId
           
       LEFT JOIN ObjectDate AS ObjectDate_DateIn
                            ON ObjectDate_DateIn.ObjectId = Object_Personal.Id
                           AND ObjectDate_DateIn.DescId = zc_ObjectDate_Personal_In()
       LEFT JOIN ObjectDate AS ObjectDate_DateOut
                            ON ObjectDate_DateOut.ObjectId = Object_Personal.Id
                           AND ObjectDate_DateOut.DescId = zc_ObjectDate_Personal_Out()          
 WHERE Object_Personal.DescId = zc_Object_Personal();


ALTER TABLE Object_Personal_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 09.11.13                                        * add DescId
 28.10.13                        *
 30.09.13                                        *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_Personal_View

-- Function: gpGet_Object_Client_NEW2_SYBASE()

DROP FUNCTION IF EXISTS gpGet_Object_Client_NEW2_SYBASE (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Client_NEW2_SYBASE(
    IN inName   TVarChar
)
RETURNS TVarChar
AS
$BODY$
BEGIN

     RETURN (WITH tmp AS 
(select tmp.Name, tmp.Name_new
from (
          select '5 ЭЛЕМЕНТ Катя' as Name, 'Игнатенко Екатерина'  as Name_new
union all select '5 элемент', '"5 элемент"' 
union all select 'CCмечко Ольга', 'Смечко Ольга' 
union all select 'Kатя-Лена 5 элемент', '"5 элемент"' 
union all select 'Агафонов Вадик', 'Агафонов Вадим' 
union all select 'Акинина Вика', 'Акинина Виктория' 
union all select 'Александр Зельманович', 'Зельманович Александр' 
union all select 'Алексеенко Кладия', 'Алексеенко Клавдия' 
union all select 'Ализаде Юля', 'Ализаде Юлия' 
union all select 'Алина Терри', 'Никитина Алина' 
union all select 'Алла Сопра', 'Андрусевич Алла' 
union all select 'Амигуд Рая', 'Амигуд Раиса' 
union all select 'Белоцирковская Дарина', 'Белоцерковцева Дарина,Владимир' 
union all select 'Белошапка Наталия', 'Белошапка Наталья' 
union all select 'Береза Антон', 'Береза Антон Олегович' 
union all select 'Беспалова Алёна', 'Беспалова Алена' 
union all select 'Билык Наталия', 'Билык Наталья' 
union all select 'Бобылев Алесандр Фадеевич', 'Бобылев Александр Фадеевич' 
union all select 'Бобылёв Александр Фадеевич', 'Бобылев Александр Фадеевич' 
union all select 'Бондарь Михаил, Мария Харьков', 'Бондарь Михаил Мария' 
union all select 'Борисенко Саша Анна', 'Борисенко Александр Анна' 
union all select 'Боченко Марина', 'Боченко Марианна Генриховна' 
union all select 'Брагинский Слава', 'Брагинский Вячеслав' 
union all select 'Бродская Юля', 'Бродская Юлия' 
union all select 'Буряк Лариса', 'Буряк Лариса, Гарик' 
union all select 'Буткевич  Валентина', 'Буткевич Валентина' 
union all select 'Бутских Оля', 'Бутских Ольга' 
union all select 'Быба Лилия', 'Быба Лилия Викторовна' 
union all select 'Вагиляйтер Наташа', 'Вагиляйтер Наталья' 
union all select 'Валентин Кривич Женя', 'Кривич  Валентин Женя' 
union all select 'Васики Саша Лена', 'Васики Александр Елена' 
union all select 'Васильева Светлана', 'Васильева Светлана Анатольевна' 
union all select 'Веретельникова Люсьена', 'Веретенникова Людмила' 
union all select 'Власенко Иллона Викторовна', 'Власенко Илона Викторовна' 
union all select 'Водопьян Елена', 'Водопьян Елена Анатольевна' 
union all select 'Володенков   Александр', 'Володенков Александр' 
union all select 'Гасанова Наташа', 'Гасанова Наталья' 
union all select 'Глущенко Саша Яна', 'Глущенко Александр Яна' 
union all select 'Гороховская Илона', 'Гороховская Илона' 
union all select 'Гречина Марьянна', 'Гречина Марьяна' 
union all select 'Грицай Игорь,Таня', 'Грицай Игорь,Татьяна' 
union all select 'Губа Эллона', 'Губа Илона' 
union all select 'Гуляев Валера Елена', 'Гуляев Валерий Елена' 
union all select 'Гуляев Валерий', 'Гуляев Валерий Елена' 
union all select 'Гущенко Юра,Нила', 'Гущенко Юрий, Нила' 
union all select 'Гущенко Юрий', 'Гущенко Юрий, Нила' 
union all select 'ДОЦЕНКО ЮРА', 'Доценко Юрий' 
union all select 'Даниил Зайцев', 'Зайцев Даниил' 
union all select 'Данилов Дима', 'Данилов Дмитрий' 
union all select 'Данина Любовь', 'Данина Любовь Яна' 
union all select 'Данина Яна Люба', 'Данина Любовь Яна' 
union all select 'Дектярёва Виктория', 'Дегтярёва Виктория' 
union all select 'Демьяненко Таня, Миша', 'Демьяненко Татьяна, Михаил' 
union all select 'Дина Ермолаева', 'Ермолаева Дина' 
union all select 'Довгань Дюдмила', 'Довгань Людмила' 
union all select 'Донец Татьяна', 'Донец Татьяна Анатольевна' 
union all select 'Доровская Ксения Виктор', 'Доровская  Ксения,Виктор' 
union all select 'Евгений+Ольга', 'Евгений,Ольга' 
union all select 'Евгения Георгиевна', 'Рогожан Евгения Георгиевна' 
) as tmp
where Name_new <> '')

            SELECT trim (Name_new)
            FROM tmp
            where lower (trim (Name)) = lower (trim (inName))
              and inName <> ''
            -- limit 1
           )
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.04.18                                        *
*/

-- тест
-- SELECT * FROM gpGet_Object_Client_NEW2_SYBASE ('Иван Елениди')

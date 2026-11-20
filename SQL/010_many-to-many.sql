drop table Students;

create table Students
(
	id int,
	name nvarchar(20)
);

insert into Students values(1, 'Anders');
insert into Students values(2, 'Maria');
insert into Students values(3, 'Thomas');
insert into Students values(4, 'Erik');
insert into Students values(5, 'Marie');

drop table Courses;

create table Courses
(
	id int,
	name nvarchar(20)
);

insert into Courses values(1, 'C#');
insert into Courses values(2, 'Databaser');
insert into Courses values(3, 'Webutveckling');
insert into Courses values(4, 'Python');

drop table StudentsCourses

create table StudentsCourses
(
	studentId int,
	courseId int
);

insert into StudentsCourses values(1, 1);
insert into StudentsCourses values(2, 1);
insert into StudentsCourses values(4, 1);
insert into StudentsCourses values(5, 1);
insert into StudentsCourses values(1, 2);
insert into StudentsCourses values(2, 2);
insert into StudentsCourses values(4, 2);
insert into StudentsCourses values(1, 3);
insert into StudentsCourses values(4, 3);
insert into StudentsCourses values(5, 3);

select * from Students;
select * from Courses;
select * from StudentsCourses;

select
	s.name as 'Student',
	c.name as 'Course'
from
	Courses c
	join StudentsCourses sc on c.id = sc.courseId
	join Students s on s.id = sc.studentId



clear
clf

x_max = 50;
y_max = 50;
x_min = -50;
y_min = -50;

obstacle_vertexes_{1,1}.x = [0 ,-10, 0 ,15, 20,30,20];
obstacle_vertexes_{1,1}.y = [0, 10, 20, 10, 20,10,0];

% obstacle_vertexes_{1,1}.x = [0 , 20, 50];
% obstacle_vertexes_{1,1}.y = [25, 30, 25];

point_test = [10,18];

old_x = obstacle_vertexes_{1,1}.x;
old_y = obstacle_vertexes_{1,1}.y;
vertex_num = size(old_x, 2);

nearest_distance_square = Inf;

for i = 1:vertex_num
	distance_square = (old_x(i) - point_test(1))^2 + (old_y(i) - point_test(2))^2;
    if (distance_square < nearest_distance_square)
        
        % intersection check
        Line_P_start.x1 = point_test(1);
        Line_P_start.y1 = point_test(2);
        Line_P_start.x2 = old_x(i);
        Line_P_start.y2 = old_y(i);
        
        check_x = old_x;
        check_y = old_y;
        check_x(i) = [];
        check_y(i) = [];
        check_x = [check_x check_x(1)];
        check_y = [check_y check_y(1)];
        for j = 1:(vertex_num-1)
            Line_border_j.x1 = check_x(j);
            Line_border_j.y1 = check_y(j);
            Line_border_j.x2 = check_x(j+1);
            Line_border_j.y2 = check_y(j+1);
            
            if intersection_check(Line_P_start, Line_border_j) == true
                continue
            end
            nearest_vertex = i;
            nearest_distance_square = distance_square;
        end
    end
end

line_start = nearest_vertex;

line_end_1 = nearest_vertex - 1;
if line_end_1 == 0
    line_end_1 = vertex_num;
end

line_end_2 = nearest_vertex + 1;
if line_end_2 == vertex_num + 1
    line_end_2 = 1;
end

Line_P_end1.x1 = point_test(1);
Line_P_end1.y1 = point_test(2);
Line_P_end1.x2 = old_x(line_end_1);
Line_P_end1.y2 = old_y(line_end_1);

Line_start_end_2.x1 = old_x(line_start);
Line_start_end_2.y1 = old_y(line_start);
Line_start_end_2.x2 = old_x(line_end_2);
Line_start_end_2.y2 = old_y(line_end_2);

if intersection_check(Line_P_end1, Line_start_end_2)==false
    % line_end_1 selected
    if (line_end_1 == vertex_num)
        new_x = [old_x(1:end) point_test(1)];
        new_y = [old_y(1:end) point_test(2)];
    else
        new_x = [old_x(1:line_end_1) point_test(1) old_x(line_start:end)];
        new_y = [old_y(1:line_end_1) point_test(2) old_y(line_start:end)];
    end
else
    % line_end_2 selected
    if (line_end_2 == 1)
        new_x = [old_x(1:end) point_test(1)];
        new_y = [old_y(1:end) point_test(2)];
    else
        new_x = [old_x(1:line_start) point_test(1) old_x(line_end_2:end)];
        new_y = [old_y(1:line_start) point_test(2) old_y(line_end_2:end)];
    end
end

% Connect polygon start end point
old_x = [old_x old_x(1)];
old_y = [old_y old_y(1)];

new_x = [new_x new_x(1)];
new_y = [new_y new_y(1)];

figure(1)
plot(old_x, old_y, 'k')
xlim([x_min x_max])
ylim([y_min y_max])
hold on

plot(new_x, new_y, 'r--')

% Calculate and compare s
old_s = 0;
for i = 1: vertex_num
    a = old_x(i)*old_y(i+1)-old_x(i+1)*old_y(i);
    old_s = old_s + a;
end

old_s = abs(old_s/2);

new_s = 0;
for i = 1: vertex_num+1
    a = new_x(i)*new_y(i+1)-new_x(i+1)*new_y(i);
    new_s = new_s + a;
end

new_s = abs(new_s/2);

% result
if (new_s < old_s)
    fprintf('point in polygon\r\n');
elseif(new_s == old_s)
    fprintf('point over polygon\r\n');
else
    fprintf('point out polygon\r\n');
end


function intersection_result = intersection_check(Line1, Line2)
    if   max(Line1.x1, Line1.x2) < min(Line2.x1, Line2.x2) || ...
         max(Line1.y1, Line1.y2) < min(Line2.y1, Line2.y2) || ...
         max(Line2.x1, Line2.x2) < min(Line1.x1, Line1.x2) || ...
         max(Line2.y1, Line2.y2) < min(Line1.y1, Line1.y2) 
        intersection_result = false;
    elseif (((Line1.x1 - Line2.x1)*(Line2.y2 - Line2.y1) - (Line1.y1 - Line2.y1)*(Line2.x2 - Line2.x1))* ...
        ((Line1.x2 - Line2.x1)*(Line2.y2 - Line2.y1) - (Line1.y2 - Line2.y1)*(Line2.x2 - Line2.x1))) > 0 || ...
        (((Line2.x1 - Line1.x1)*(Line1.y2 - Line1.y1) - (Line2.y1 - Line1.y1)*(Line1.x2 - Line1.x1))* ...
        ((Line2.x2 - Line1.x1)*(Line1.y2 - Line1.y1) - (Line2.y2 - Line1.y1)*(Line1.x2 - Line1.x1))) > 0
        intersection_result = false;
    else
        intersection_result = true;
    end
end

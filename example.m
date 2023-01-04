
clc
clear
close all

map = mapMaze( 1, 1, "MapSize", [5 5]);
map = occupancyMatrix( map );
map = double( map );
[ n, m] = size( map );

walls = map == 1;
wallInds = find( walls );
[ wallII, wallJJ] = ind2sub( [ n, m], wallInds);

inds = find( map == 0 );
startInd = min( inds );
targetInd = max( inds );

[ startII, startJJ] = ind2sub( [ n, m], startInd);
[ targetII, targetJJ] = ind2sub( [ n, m], targetInd);

dijkstraObject = {};
dijkstraObject.start = [ startII, startJJ];
dijkstraObject.target = [ targetII, targetJJ];
dijkstraObject.moves = @( p, obj) moves( p, obj);

dijkstraObject.walls = [ wallII, wallJJ];
dijkstraObject.map = map;

result = dijkstra( dijkstraObject )

saveGIF = true;
animateSolution( result, saveGIF);


function [possibleMoves] = moves( location, dijkstraObject)

    walls = dijkstraObject.walls;
    visited = dijkstraObject.visited;

    kernel = [ 0, 1;
               1, 0;
              -1, 0;
               0,-1];

%     % Diagonal moves
%     kernel = [ 0, 1;
%                1, 0;
%               -1, 0;
%                0,-1;
%               -1,-1;
%                1,-1;
%                1, 1;
%               -1, 1];

    possibleMoves = location + kernel;
    inds = ~ismember( possibleMoves, walls, "rows");
    
    if( ~isempty( visited ) )
        inds = inds & ~ismember( possibleMoves, visited, "rows");
    end

    possibleMoves = possibleMoves( inds, :);
end

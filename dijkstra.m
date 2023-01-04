function [outputObject] = dijkstra( inputObject )
    
    start = inputObject.start;
    target = inputObject.target;
    startIsTarget = all( start == target );

    if( startIsTarget )
        outputObject = inputObject;
        outputObject.paths = {start};
        outputObject.path = start;
        outputObject.distance = 0;
        return;
    end

    visitedExists = isfield( inputObject, "visited");

    if( ~visitedExists )
        inputObject.visited = [];
    end

    possibleMoves = inputObject.moves( start, inputObject);

    includesTarget = ismember( target, possibleMoves, "rows");
    includesTarget = any( includesTarget );

    movesNext = possibleMoves;
    nPaths = size( movesNext, 1);

    previousNext = repmat( start, nPaths, 1);
    previousVector = {previousNext};

    inputObject.paths = {start};
    inputObject.paths{end + 1} = movesNext;
    
    distance = 1;
    while( ~includesTarget )
        
        paths = movesNext;
        movesNext = [];
        previousNext = [];

        nPaths = size( paths, 1);

        if( nPaths == 0 )
            break;
        end
        
        for ii = 1:nPaths
            
            path_ii = paths( ii, :);
            paths_ii = inputObject.moves( path_ii, inputObject);
            nPaths_ii = size( paths_ii, 1);
            
            includesTarget = ismember( target, paths_ii, "rows");
            includesTarget = any( includesTarget );
                
            inputObject.visited = [ inputObject.visited; paths_ii];
%             inputObject.visited = unique( inputObject.visited, "rows");

            movesNext = [ movesNext; paths_ii];

            previous_ii = repmat( path_ii, nPaths_ii, 1);
            previousNext = [ previousNext; previous_ii];

            if( includesTarget )
                break;
            end
        end

        distance = distance + 1;
        inputObject.paths{end + 1} = movesNext;
        previousVector{end + 1} = previousNext;
    end

    outputObject = inputObject;
    outputObject.distance = distance;

    if( ~includesTarget )
        outputObject.targetReached = false;
        outputObject.path = [];
        return;
    end

    paths = outputObject.paths;

    outputObject.targetReached = true;
    outputObject.path = computeShortestPath( target, paths, previousVector);
end


function [shortestPath] = computeShortestPath( target, paths, previous)

    nSteps = length( paths );
    current = target;

    shortestPath = zeros( nSteps, 2);
    shortestPath( nSteps, :) = current;

    for ii = nSteps:-1:2
        
        paths_ii = paths{ii};
        previous_ii = previous{ii - 1};

        ind = ismember( paths_ii, current, "rows");
        current = previous_ii( ind, :);

        shortestPath( ii - 1, :) = current;
    end
end

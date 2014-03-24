using Twilert

function error_program()
    # We're doing some stuff and BAM we hit an error...
    try
        x = 1
        if x == 1
            error("Onhoes!")
        end
    catch
        Twilert.alert("Ohnoes! There was an error in ur codez!")
    end
end

function success_program()
    # Program is all done, so we let ourselves know!
    x = 0
    for i = 1:100
        x += i
    end
    Twilert.alert("Yay! All done, good job!")
end

error_program()
success_program()

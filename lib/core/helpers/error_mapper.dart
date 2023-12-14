class UnathorizedError extends Error{
    final String message;

    UnathorizedError({required this.message});

    @override
    String toString() {
        return message;
    }
}

class UserNotFoundException extends Error{
    final String message;

    UserNotFoundException({required this.message});

    @override
    String toString() {
        return message;
    } 
}
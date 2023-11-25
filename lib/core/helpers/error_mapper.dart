class UnathorizedError extends Error{
    final String message;

    UnathorizedError({required this.message});

    @override
    String toString() {
        // TODO: implement toString
        return message;
    }
}
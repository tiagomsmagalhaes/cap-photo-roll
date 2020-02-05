declare module "@capacitor/core" {
    interface PluginRegistry {
        PhotoRoll: PhotoRollPlugin;
    }
}
export interface PhotoRollPlugin {
    echo(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
}

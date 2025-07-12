import subprocess

def getpassword(service, key):
    try:
        # Für secret-tool
        if service.endswith('.com'):
            result = subprocess.run(
                ['secret-tool', 'lookup', 'service', service, 'key', key],
                check=True, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL
            )
        # Für pass
        else:
            result = subprocess.run(
                ['pass', f"{service}/{key}"],
                check=True, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL
            )
        return result.stdout.decode('utf-8').strip()
    except subprocess.CalledProcessError:
        raise ValueError(f"Lookup failed for {key} in {service}")
